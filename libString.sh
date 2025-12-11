#!/usr/bin/env bash

################################################################################
# @file         libString.sh
# @brief        Source variables and functions to treat and validate strings.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

function genVersionStr() { local vector=("${@}") ; echo -n "${vector[0]}.${vector[1]}.${vector[2]}" ; }
function genVersionNum() { local vector=("${@}") ; echo -n $((vector[0]*100 + vector[1]*10 + vector[2])) ; }
function genDateVersionStr() { local vector=("${@}") ; printf "%04d-%02d-%02d" ${vector[0]} ${vector[1]} ${vector[2]} ; }
function genDateVersionNum() { local vector=("${@}") ;  echo -n $((vector[0]*1000000 + vector[1]*1000 + vector[2])) ; }
function isYes() { case "$1" in [yY] | [yY][eE][sS]) true ;; *) false ;; esac ; }
function isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }
function isEmpty()  { if [ -n "$1" ] ; then false ; else true  ; fi ; }
function notEmpty() { if [ -n "$1" ] ; then true  ; else false ; fi ; }
function isParam()  { if [ -z "$1" ] ; then false ; else { case "$1" in --*) true ;; -[0-9]) false ;; -*) true ;; *) false ;; esac ; } ; fi ; }
function isArg()    { if [ -z "$1" ] ; then false ; else { case "$1" in --*) false ;; -*) false ;; *) true ;; esac ; } ; fi ; }
function getDate() { echo -n "$(date '+%Y-%m-%d')" ; }
function getTime() { echo -n "$(date '+%H:%M:%S')" ; }
function getDateTime() { echo -n "$(getDate) $(getTime)" ; }
function strLen(){ echo -n ${#1} ; }
function cmpStr()
{
    if   [ "$1" \< "$2" ] ; then echo -n -1
    elif [ "$1" \> "$2" ] ; then echo -n  1
    else echo -n 0
    fi
}
function libStringExit()
{
    unset -f genVersionStr
    unset -f genVersionNum
    unset -f genDateVersionStr
    unset -f genDateVersionNum
    unset -f isYes
    unset -f isNot
    unset -f isEmpty
    unset -f notEmpty
    unset -f isParameter
    unset -f isArgValue
    unset -f getDate
    unset -f getTime
    unset -f getDateTime
    unset -f strLen
    unset -f cmpStr
    return 0
}
