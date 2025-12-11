#!/usr/bin/env bash

################################################################################
# @file         libGit.sh
# @brief        Source variables and functions to manage git repositories.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

function isGitRepository()
{
    local target="$1"
    local err=1
    if notEmpty "${target}" ; then
        if isLink "${target}" ; then
            target="$(followLink "${target}")"
        fi
        if isFile "${target}" ; then
            target="$(getPath "${target}")"
        fi
        if itExist "${target}/.git"
        then
            git -C "${target}" rev-parse --git-dir > /dev/null 2>&1
            err=$?
            [ $err -eq 0 ] && true || false
        else
            false
        fi
    fi
    return $err
}
function isBranchCurrent()  { local err ; git branch -q --show-current | grep -oF "$1" > /dev/null 2>&1 ; err=$? ; [ $err -eq 0 ] && true || false ; return $err ; }
function isBranchAhead()    { local err ; git status | grep -qoE ' ahead ' ; err=$? ; [ $err -eq 0 ] && true || false ; return $err ; }
function isBranchBehind()   { local err ; git status | grep -qoE ' behind ' ; err=$? ; [ $err -eq 0 ] && true || false ; return $err ; }
function isBranchUpToDate() { local err ; git status | grep -qoE ' up to date ' ; err=$? ; [ $err -eq 0 ] && true || false ; return $err ; }
function isGitChanged()
{
    declare -i err=0
    declare -i count=0
    declare -i acc=0
    declare -i index
    for ((index = 0 ; index < libGitMAXTABLELETTERS ; index++))
    do
        count=$(gitCountChanges ${libGitTABLELETTERS[$index]}) || err=$?
        acc=$((acc + count))
    done
    if [ $acc -gt 0 ]
    then
        true
    else
        false
    fi
    return $err
}
function existBranch() { local err ; git branch -q | grep -oF "$1" > /dev/null 2>&1 ; err=$? ; [ $err -eq 0 ] && true || false ; return $err ; }
function newBranch()   { local err ; git branch -q "$1" > /dev/null 2>&1 ; err=$? ; return $err ; }
function createBranch()
{
    local branch="$1"
    [ -n "${branch}" ] || return 1
    local err=0
    newBranch                 "${branch}" || { err=$? ; logE "newBranch(${branch}) return code:$err" ; }
    gitSwitch                 "${branch}" || { err=$? ; logE "gitSwitch(${branch}) return code:$err" ; }
    gitSetLocalPushUpstream   "${branch}" || { err=$? ; logE "gitSetLocalPushUpstream(${branch}) return code:$err" ; }
    gitSetupRebase            "${branch}" || { err=$? ; logE "gitSetupRebase(${branch}) return code:$err" ; }
    gitConfigBranchMerge      "${branch}" || { err=$? ; logE "gitConfigBranchMerge(${branch}) return code:$err" ; }
    gitConfigBranchPushRemote "${branch}" || { err=$? ; logE "gitConfigBranchPushRemote(${branch}) return code:$err" ; }
    gitConfigAutoSetupMerge   "${branch}" || { err=$? ; logE "gitConfigAutoSetupMerge(${branch}) return code:$err" ; }
    return $err
}
function gitRebase()                { local err ; git rebase -m HEAD "$1" > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitSetupRebase()           { local err ; git config pull.rebase false > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitConfigBranchMerge()     { local err ; git config branch."$1".merge > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitConfigBranchPushRemote(){ local err ; git config branch."$1".pushRemote > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitConfigAutoSetupMerge()  { local err ; git config branch.autoSetupMerge always > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitSetLocalPushUpstream()  { local err ; git push -q --set-upstream origin "$1" > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitBranchName()            { local err res ; res=$(git branch -q --show-current) ; err=$? ; echo -n "${res}" ; return $err ; }
function gitRepositoryName()        { local err res ; res="$(git rev-parse --show-toplevel)" ; err=$? ; echo -n "$(basename ${res})" ; return $err ; }
function gitCountChanges()          { local err count ; count=$(git status --porcelain | grep -cP "^$1 |$1. |.$1 ") ; err=$? ; echo -n $count ; return $err ; }
function gitAnyChanges()
{
    local err=0
    declare -i count=0
    declare -i acc=0
    declare -i index
    for ((index = 0 ; index < libGitMAXTABLELETTERS ; index++))
    do
        count=$(gitCountChanges ${libGitTABLELETTERS[$index]}) || err=$?
        acc=$((acc + count))
    done
    echo -n $acc
    return $err
}
function gitCommitCounter()
{
    declare -i -r maxLen=$([ -n "$1" ] && echo $1 || echo 4)
    local line=''
    declare -i len counter direction
    counter=0
    if   line="$(git status | grep -F ' behind ')" ; then direction=-1
    elif line="$(git status | grep -F ' ahead ' )" ; then direction=1
    else { echo -n $counter ; return 0 ; }
    fi
    line="${line##*by }"
    for ((len=0 ; len < $maxLen ; len++)) ; do case "${line:$len:1}" in [0-9]) continue ;; *) break ;; esac ; done
    if [ $len -gt 0 ] ; then printf -v counter '%d' "${line:0:$len}" ; fi
    counter=$((counter * direction))
    echo -n $counter
    return 0
}
function gitAdd()            { local err ; git add "$1" > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitCommitNotSigned(){ local err ; git commit -q -m "${1}" > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitCommitSigned()   { local err ; git commit -q -s -m \""${1}"\" > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitFetch()          { local err ; git fetch  -q origin HEAD > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitPull()           { local err ; git pull   -q origin HEAD > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitPush()           { local err ; git push   -q origin HEAD > /dev/null 2>&1 ; err=$? ; return $err ; }
function gitSwitch()         { local err ; git switch -q "$1" > /dev/null 2>&1 ; err=$? ; return $err ; }

function libGitExit()
{
    unset -f isGitRepository
    unset -f isBranchCurrent
    unset -f isBranchAhead
    unset -f isBranchBehind
    unset -f isBranchUpToDate
    unset -f isGitChanged
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
