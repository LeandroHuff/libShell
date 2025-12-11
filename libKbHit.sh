#!/usr/bin/env bash

################################################################################
# @file         libKbHit.sh
# @brief        Source variables and functions to detect keyboard key pressed.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

function kbhit()
{
    local wait=$([ -n "$2" ] && echo -n "$2" || echo -n '1.0')
    read -s -n 1 -t $wait && return 0
    return 1
}

function libKbHitExit()
{
    # Unset Functions
    unset -f kbhit
    unset -f libKbHitExit
    # Return Code
    return 0
}
