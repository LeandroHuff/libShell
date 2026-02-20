################################################################################
# @file         libGit.sh
# @brief        Source variables and functions to manage git repositories.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libGit.sh
################################################################################

# Must be sourced not running
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running."
    exit 1
fi

## @brief   Variable to store libGit status on load successfully.
declare libGit=''

## @brief   Variable to store an array of letters to be used to find changes on repository.
# A Added
# C Copied
# D Deleted
# M Modified
# R Renamed
# T Type changed
# U Unmerged
# ? Untracked
# ! Ignored
# '\' to be compatible with regex search
declare -a StatusLetters=('A' 'C' 'D' 'M' 'R' 'T' 'U' '\?' '!')

##
# @brief    Check a path parameter for a valid git repository.
# @param    "$1"        Path, assume current path './' for empty parameter.
# @result   none
# @return   0           Success, path/ IS a git repository.
#           1           Failure, path/ is NOT a git repository.
function isGitRepository()
{
    if git -C "${1:-./}" rev-parse --git-dir > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Check if parameter is the current branch's name in the current directory.
# @param    "$1"        Branch's name for current repository.
# @result   none
# @return   0           The parameter is the current branch's name in the respotiroy.
#           1           The parameter is not the current branch's name in the respoitory.
function isBranchCurrent()
{
    if git branch -q --show-current | grep -qaoP "^${1:-'null'}$"
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Check if the current branch is up to date with the remote repository.
# @param    none
# @result   none
# @return   0           The local repository/branch is up to date with the remote.
#           1           The local repository/branch is NOT up to date with the remote.
function isBranchUpToDate()
{
    if git status | grep -qoF ' up to date '
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Check local branch status to verify if it are ahead of remote repository.
# @param    none
# @result   none
# @return   0           The local repository is ahead of remote repository.
#           1           The local repository is NOT ahead of remote repository.
function isBranchAhead()
{
    if git status | grep -qoF ' ahead '
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Check local branch status to verify if it are behind of remote repository.
# @param    none
# @result   none
# @return   0           The local repository is behind of remote repository.
#           1           The local repository is NOT behind of remote repository.
function isBranchBehind()
{
    if git status | grep -qoF ' behind '
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Get counter behind commits.
# @param    "$1"        Maximum number length, default is 4 digits, 0..9999
# @result   integer     Counter, commits behind counter.
# @return   0           Success
#           1..N        Failure
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
# @return   0           Success
#           1..N        Failure
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
# @param    "$1"        Character, letter to search and count changes.
# @result   integer     Counter, changes counter.
# @return   0           Success
#           1..N        Failure or empty parameter.
function gitCountChanges()
{
    if ! [ -n  "${1}" ] || ! [[ "${StatusLetters[@]}" =~ "${1}" ]]
    then
        return 1
    fi
    local count=$(git status --porcelain | grep -cE "^$1 |$1. |.$1 ")
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
# @result   none
# @return   0           No one changes.
#           N           N changes in the current repository/branch.
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
# @param    "$1"        Branch's name.
# @result   none
# @return   0           Success, branch EXIST in current repository.
#           1..N        Failure, branch does NOT EXIST in the current repository.
function existBranch()
{
    if git branch -q | grep -aoE "${1:-'null'}$" > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Create a new branch in the current repository.
# @param    "$1'        Branches name.
# @result   none
# @return   0           Success
#           1..N        Failure or empty parameter
function newBranch()
{
    [ -n "${1}" ] || return 1
    if git branch -q "${1}" > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Reapply commits from branch or current branch on top of another target tip.
# @param    "$1"        Source branch or current branches name to rebase into the top of target.
# @result   none
# @return   0           Success
#           1           Failure
function gitRebase()
{
    [ -n "${1}" ] || return 1
    if git rebase -m HEAD "${1}" > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Config current branch for pull rebase as false.
# @param    none
# @result   none
# @return   0           Success
#           1..N        Failure
function gitSetupPullRebase()
{
    if git config pull.rebase false > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Configure current branch for merge into target (parameter) branch.
#           branch.<name>.merge, it tells git fetch/git pull/git rebase which branch to merge.
# @param    "$1"        Target (rebase) branches name.
# @result   none
# @return   0           Success
#           1..N        Failure or empty parameter.
function gitConfigBranchMerge()
{
    [ -n "${1}" ] || return 1
    if git config branch."${1}".merge always > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Configure branch for push to default remote repository.
# @param    none        Assume current branches name.
# @result   none
# @return   0           Success
#           1           Failure
function gitConfigBranchPushDefault()
{
    if git config remote.pushDefault > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Configurate branch for auto merge.
# @param    none
# @result   none
# @return   0           Success
#           1..N        Failure
function gitConfigAutoSetupMerge()
{
    if git config branch.autoSetupMerge > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Configure repository for push on upstream.
# @param    "$1"        Set upstream to.
# @result   none
# @return   0           Success
#           1..N        Failure or empty parameter.
function gitSetLocalPushUpstream()
{
    [ -n "${1}" ] || return 1
    if git push -q --set-upstream origin "${1}" > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Get current branch's name.
# @param    none
# @result   string      Branch's name.
# @return   0           Success
#           1..N        Failure
function gitBranchName()
{
    local res=$(git branch -q --show-current)
    local err=$?
    echo -n "${res}"
    return $err
}

##
# @brief    Delete branches name targeted by parameter.
# @param    "$1"        Branch name to be deleted, can not be current branch.
# @result   none
# @return   0           Success
#           1           Empty parameter.
#           2           Parameter match current branch.
#           3           Delete branch failure.
function gitBranchDelete()
{
    [ -n "${1}" ] || return 1
    if [[ "${1}" == "$(gitBranchName)" ]]
    then
        return 2
    elif git branch -q -d "${1}" > /dev/null 2>&1
    then
        return 0
    else
        return 3
    fi
}

##
# @brief    Is branch name in list.
# @param    "$1"        Branch name.
# @result   none
# @return   0           Yes in in list.
#           1           No, is not in list.
function gitHaveBranch()
{
    [ -n "${1}" ] || return 1
    if git branch | grep -aoE "${1}$" > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Get git repository's name.
# @param    none
# @result   string      Repository's name.
# @return   0           Success
#           1..N        Failure
function gitRepositoryName()
{
    local res="$(git rev-parse --show-toplevel)"
    local err=$?
    echo -n "$(basename ${res})"
    return $err
}

##
# @brief    Create a new branch, change to it, set it up as local push upstream, rebase, merge and auto merge.
# @param    "$1"        Branch's name.
#           "$2"        Branch to set upstream or current for empty.
# @result   none
# @return   0           Success
#           1..N        Failure or empty parameter.
function createBranch()
{
    local error='\033[31m  error\033[0m:'
    [ -n "${1}" ] || { echo -e "${error} Empty parameter to function createBranch()" ; return 1 ; }
    local branch="${1}"
    local current="$([ -n "${2}" ] && echo -n "${2}" || echo -n "$(gitBranchName)")"
    local err=0
    newBranch "${branch}" || { err=$? ; echo -e "${error} newBranch(${branch}) return code:$err" ; }
    gitSwitch "${branch}" || { err=$? ; echo -e "${error} gitSwitch(${branch}) return code:$err" ; }
    if [ -n "${current}" ]
    then
        gitSetLocalPushUpstream "${current}"
        err=$?
        [ $err -eq 0 ] || echo -e "${error} gitSetLocalPushUpstream(${current}) return code:$err"
    fi
    gitSetupPullRebase                    || { err=$? ; echo -e "${error} gitSetupRebase(${branch}) return code:$err" ; }
    gitConfigBranchMerge      "${branch}" || { err=$? ; echo -e "${error} gitConfigBranchMerge(${branch}) return code:$err" ; }
    gitConfigAutoSetupMerge   "${branch}" || { err=$? ; echo -e "${error} gitConfigAutoSetupMerge(${branch}) return code:$err" ; }
    return $err
}

##
# @brief    Add new and changed files contents to the index.
# @param    "$1"        Files to add, for empty parameters assume a '.' as a default
#                       wilcard to include all files and changes.
# @result   none
# @return   0           Success
#           1           Failure
function gitAdd()
{
    if git add "${1:-.}" > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Commit all added/staged changes with NO signed commit.
# @param    "$1"        Message to append to commit or a default message with user, date and time.
# @result   none
# @return   0           Success
#           1           Failure
function gitCommitNotSigned()
{
    declare message='' res='' err=0
    [ -n "${1}" ] && message="${1}" || message="Updated by $USER on $(date +%Y-%m-%d) at $(date +%H:%M:%S)"
    res="$(git commit -q -m "${message}")"
    err=$?
    if ((err > 0))
    then
        echo -n "${res}" | grep -qoF 'nothing to commit' > /dev/null 2>&1
        err=$?
    fi
    return $err
}

##
# @brief    Commit all added/staged changes with SIGNED commit.
# @param    "$1"        Message to append to commit or a default message with user, date and time.
# @result   none
# @return   0           Success
#           1           Failure
function gitCommitSigned()
{
    declare message='' res='' err=0
    [ -n "${1}" ] && message="${1}" || message="Updated by $USER on $(date +%Y-%m-%d) at $(date +%H:%M:%S)"
    res="$(git commit -q -s -m "${message}")"
    err=$?
    if ((err > 0))
    then
        echo -n "${res}" | grep -qoF 'nothing to commit' > /dev/null 2>&1
        err=$?
    fi
    return $err
}

##
# @brief    Download objects and refs from remote repository.
# @param    none
# @result   none
# @return   0           Success
#           1..N        Failure
function gitFetch()
{
    if git fetch -q origin HEAD > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Fetch from remote site and integrate into a local branch.
# @param    none
# @result   none
# @return   0           Success
#           1..N        Failure
function gitPull()
{
    if git pull -q origin > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Update remote refs an changes along with local branch objects.
# @param    none
# @result   none
# @return   0           Success
#           1..N        Failure
function gitPush()
{
    if git push -q origin HEAD > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Switch branches to the repository branches list.
# @param    "$1"        Branch's name to switch to.
# @result   none
# @return   0           Success
#           1..N        Failure
function gitSwitch()
{
    [ -n "${1}" ] || return 1
    if git switch -q "${1}" > /dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Finish libGit, unset variables and functions.
# @param    none
# @result   none
# @return   0           Success
function libGitExit()
{
    unset -v libGit
    unset -v StatusLetters
    unset -f isGitRepository
    unset -f isBranchCurrent
    unset -f isBranchUpToDate
    unset -f isBranchAhead
    unset -f isBranchBehind
    unset -f getCounterCommitsBehind
    unset -f getCounterCommitsAhead
    unset -f gitCountChanges
    unset -f gitAnyChanges
    unset -f getRepositoryChanges
    unset -f existBranch
    unset -f newBranch
    unset -f gitRebase
    unset -f gitSetupPullRebase
    unset -f gitConfigBranchMerge
    unset -f gitConfigBranchPushRemote
    unset -f gitConfigAutoSetupMerge
    unset -f gitSetLocalPushUpstream
    unset -f gitBranchName
    unset -f gitBranchDelete
    unset -f gitHaveBranch
    unset -f gitRepositoryName
    unset -f createBranch
    unset -f gitAdd
    unset -f gitCommitSigned
    unset -f gitCommitNotSigned
    unset -f gitFetch
    unset -f gitPull
    unset -f gitPush
    unset -f gitSwitch
    unset -f libGitExt
    return 0
}

## @brief   Set variable to control libGit successfully sourced.
libGit='loaded'
