################################################################################
# @file         libGit.sh
# @brief        Source variables and functions to manage git repositories.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libGit.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91merror\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

declare libGit=''

# A Added
# C Copied
# D Deleted
# M Modified
# R Renamed
# T Type changed
# U Unmerged
# ? Untracked
# ! Ignored
declare -a StatusLetters=('A' 'C' 'D' 'M' 'R' 'T' 'U' '\?' '\!')

##
# @brief    Check a path parameter for a valid git repository.
# @param    "$1"    Path
# @return   0       Success, path/ is a git repository.
#           1..N    Failure, path/ is not a git repository.
function isGitRepository()
{
    local target="$1"
    local err=1
    if [ -n "${target}" ] ; then
        if [ -L "${target}" ] ; then
            target="$(readlink -e "${target}")"
        fi
        if [ -f "${target}" ] ; then
            target="$(basedir "${target}")"
        fi
        if [ -d "${target}/.git" ]
        then
            git -C "${target}" rev-parse --git-dir > /dev/null 2>&1
            err=$?
        fi
    fi
    return $err
}

##
# @brief    Check if parameter is the current branch's name in the current
# directory.
# @param    "$1"    Branch's name for current repository.
# @result   true    The parameter is the current branch's name in the respotiroy.
#           false   The parameter is not the current branch's name in the
#           respoitory.
function isBranchCurrent()
{
    git branch -q --show-current | grep -qaoP "^${1:-'nil'}$"
    return $?
}

##
# @brief    Check if the current branch is up to date with the remote repository.
# @param    none
# @return   0       The local repository/branch is up to date with the remote.
#           1       The local repository/branch is NOT up to date with the remote.
function isBranchUpToDate()
{
    git status | grep -qoP ' up to date '
    return $?
}

##
# @brief    Check local branch status to verify if it are ahead of remote repository.
# @param    none
# @return   0       The local repository is ahead of remote repository.
#           1       The local repository is NOT ahead of remote repository.
function isBranchAhead()
{
    git status | grep -qoF ' ahead '
    return $?
}

##
# @brief    Check local branch status to verify if it are behind of remote repository.
# @param    none
#           0       The local repository is behind of remote repository.
#           1       The local repository is NOT behind of remote repository.
function isBranchBehind()
{
    git status | grep -qoF ' behind '
    return $?
}

##
# @brief    Get counter behind commits.
# @param    "$1"        Maximum number length, default is 4 digits, 0..9999
# @result   integer     Counter, commits behind counter.
function getCounterCommitsBehind()
{
    declare -i maxLen="${1:-4}"
    declare -i counter=0
    declare -i len
    local line="$(git status | grep -F ' behind ')"
    if [ -n "${line}" ]
    then
        line="${line##*by }"
        for ((len=0 ; len < $maxLen ; len++))
        do
            case "${line:$len:1}" in
            [0-9]) continue ;;
            *) break ;;
            esac
        done
        len=$((len+1))
        printf -v counter '%d' "${line:0:$len}"
    fi
    echo -n $counter
}

##
# @brief    Get counter ahead commits.
# @param    "$1"        Maximum number length, default is 4 digits, 0..9999
# @result   integer     Counter, commits ahead counter.
function getCounterCommitsAhead()
{
    declare -i maxLen="${1:-4}"
    declare -i counter=0
    declare -i len
    local line="$(git status | grep -F ' ahead ')"
    if [ -n "${line}" ]
    then
        line="${line##*by }"
        for ((len=0 ; len < $maxLen ; len++))
        do
            case "${line:$len:1}" in
            [0-9]) continue ;;
            *) break ;;
            esac
        done
        len=$((len+1))
        printf -v counter '%d' "${line:0:$len}"
    fi
    echo -n $counter
}

##
# @brief    Get changes counter according to letter parameter that can be one of
#           ('A' 'C' 'D' 'M' 'R' 'T' 'U' '\?' '\!') option.
# @param    "$1"    Character, letter to search and count changes.
# @result   integer Counter, changes counter.
# @return   0       Success
#           1..N    Failure or empty parameter.
function gitCountChanges()
{
    [ -n "${1}" ] || return 1
    local count=$(git status --porcelain | grep -cP "^${1} |${1}. |.${1} ")
    local err=$?
    echo -n $count
    return $err
}

##
# @brief    Check for any changes in the repository/branch.
# @param    none
# @result   integer     Accumulated changes counter.
# @return   0           Success
#           1..N        Failure
function gitAnyChanges()
{
    local err=0
    declare -i count=0
    declare -i acc=0
    for letter in "${StatusLetters[@]}"
    do
        count=$(gitCountChanges "${letter}") || err=$?
        acc=$((acc + count))
    done
    echo -n $acc
    return $err
}

##
# @brief    Get the current repository counter changes.
# @param    none
# @return   0       No one changes.
#           N       N changes in the current repository/branch.
function getRepositoryChanges()
{
    declare -i err=0
    declare -i count=0
    declare -i acc=0
    for letter in "${StatusLetters[@]}"
    do
        count=$(gitCountChanges "${letter}") || err=$?
        acc=$((acc + count))
        count=0
    done
    echo $acc
    return $err
}

##
# @brief    Check if branch parameter exist in the current repository.
# @param    "$1"    Branch's name.
# @return   0       Success, branch EXIST in current repository.
#           1..N    Failure, branch does NOT EXIST in the current repository.
function existBranch()
{
    git branch -q | grep -aoP "${1:-nil}$" > /dev/null 2>&1
    return $?
}

##
# @brief    Create a new branch in the current repository.
# @param    "$1'    Branches name.
# @return   0       Success
#           1..N    Failure or empty parameter
function newBranch()
{
    [ -n "${1}" ] || return 1
    git branch -q "${1}" > /dev/null 2>&1
    return $?
}

##
# @brief    Create a new branch, change to it, set it up as local push upstream, rebase, merge and auto merge.
# @param    "$1"    Branch's name.
# @return   0       Success
#           1..N    Failure or empty parameter.
function createBranch()
{
    [ -n "${1}" ] || return 1
    local branch="${1}"
    local err=0
    local error='\033[31m  error\033[0m:'
    newBranch                 "${branch}" || { err=$? ; echo -e "${error} newBranch(${branch}) return code:$err"               ; }
    gitSwitch                 "${branch}" || { err=$? ; echo -e "${error} gitSwitch(${branch}) return code:$err"               ; }
    gitSetLocalPushUpstream   "${branch}" || { err=$? ; echo -e "${error} gitSetLocalPushUpstream(${branch}) return code:$err" ; }
    gitSetupRebase            "${branch}" || { err=$? ; echo -e "${error} gitSetupRebase(${branch}) return code:$err"          ; }
    gitConfigBranchMerge      "${branch}" || { err=$? ; echo -e "${error} gitConfigBranchMerge(${branch}) return code:$err"    ; }
    gitConfigAutoSetupMerge   "${branch}" || { err=$? ; echo -e "${error} gitConfigAutoSetupMerge(${branch}) return code:$err" ; }
    return $err
}

##
# @brief    Rebase git branch to HEAD position.
# @param    "$1"    Branch's name.
# @return   0       Success
#           1..N    Failure or empty parameter.
function gitRebase()
{
    [ -n "${1}" ] || return 1
    git rebase -m HEAD "${1}" > /dev/null 2>&1
    return $?
}

##
# @brief    Config pull rebase as false.
# @param    none
# @return   0       sSuccess
#           1..N    Failure
function gitSetupRebase()
{
    git config pull.rebase false > /dev/null 2>&1
    return $?
}

##
# @brief    Configure branch for merge.
# @param    "$1"    Branch's name.
# @return   0       Success
#           1..N    Failure or empty parameter.
function gitConfigBranchMerge()
{
    [ -n "${1}" ] || return 1
    git config branch."${1}".merge > /dev/null 2>&1
    return $?
}

##
# @brief    Configure branch for push to remote repository.
# @param    "$1"    Branch's name.
# @return   0       Success
#           1..N    Failure or empty parameter.
function gitConfigBranchPushRemote()
{
    [ -n "${1}" ] || return 1
    git config branch."${1}".pushRemote > /dev/null 2>&1 ;
    return $?
}

##
# @brief    Configurate branch for auto merge.
# @param    none
# @return   0       Success
#           1..N    Failure
function gitConfigAutoSetupMerge()
{
    git config branch.autoSetupMerge always > /dev/null 2>&1
    return $?
}

##
# @brief    Configure repository for push on upstream.
# @param    "$1"    Branch's name.
# @return   0       Success
#           1..N    Failure or empty parameter.
function gitSetLocalPushUpstream()
{
    [ -n "${1}" ] || return 1
    git push -q --set-upstream origin "${1}" > /dev/null 2>&1
    return $?
}

##
# @brief    Get current branch's name.
# @param    none
# @result   string  Branch's name.
# @return   0       Success
#           1..N    Failure
function gitBranchName()
{
    local res=$(git branch -q --show-current)
    local err=$?
    echo -n "${res}"
    return $err
}

##
# @brief    Get git repository's name.
# @param    none
# @result   string  Repository's name.
# @return   0       Success
#           1..N    Failure
function gitRepositoryName()
{
    local res="$(git rev-parse --show-toplevel)"
    local err=$?
    echo -n "$(basename ${res})"
    return $err
}

##
# @brief    Add new and changed files contents to the index.
# @param    "$1"    Files to add, for empty parameters assume a '.' as a default
#                   wilcard to include all files and changes.
# @return   0       Success
#           1       Failure
function gitAdd()
{
    git add "${1:-.}" > /dev/null 2>&1
    return $?
}

##
# @brief    Commit all added/staged changes with no signed commit.
# @param    "$1"    Message to append to commit or a default message with user, date and time.
# @return   0       Success
#           1       Failure
function gitCommitNotSigned()
{
    local message=''
    [ -n "${1}" ] && message="${1}" || message="Updated by $USER on $(date +%Y-%m-%d) at $(date +%H:%M:%S)"
    git commit -q -m "\"${message}\"" > /dev/null 2>&1
    return $?
}

##
# @brief    Commit all added/staged changes with signed commit.
# @param    "$1"    Message to append to commit or a default message with user, date and time.
# @return   0       Success
#           1       Failure
function gitCommitSigned()
{
    local message=''
    [ -n "${1}" ] && message="${1}" || message="Updated by $USER on $(date +%Y-%m-%d) at $(date +%H:%M:%S)"
    git commit -q -s -m "\"${message}\"" > /dev/null 2>&1
    return $?
}


function gitFetch()
{
    git fetch -q origin HEAD > /dev/null 2>&1
    return $?
}


function gitPull()
{
    git pull -q origin HEAD > /dev/null 2>&1
    return $?
}


function gitPush()
{
    git push -q origin HEAD > /dev/null 2>&1
    return $?
}


function gitSwitch()
{
    [ -n "${1}" ] || return 1
    git switch -q "${1}" > /dev/null 2>&1
    return $?
}

function libGitExit()
{
    unset -v libGit

    unset -f isGitRepository
    unset -f isBranchCurrent
    unset -f isBranchAhead
    unset -f isBranchBehind
    unset -f isBranchUpToDate
    unset -f isRepositoryChanged
    unset -f existBranch
    unset -f newBranch
    unset -f createBranch
    unset -f gitRebase
    unset -f gitSetupRebase
    unset -f gitConfigBranchMerge
    unset -f gitConfigBranchPushRemote
    unset -f gitConfigAutoSetupMerge
    unset -f gitSetLocalPushUpstream
    unset -f gitBranchName
    unset -f gitRepositoryName
    unset -f gitCountChanges
    unset -f gitAnyChanges
    unset -f gitCommitCounter
    unset -f gitAdd
    unset -f gitCommitNotSigned
    unset -f gitCommitSigned
    unset -f gitFetch
    unset -f gitPull
    unset -f gitPush
    unset -f gitSwitch
    unset -f libGitExit
    return 0
}

libGit='loaded'
