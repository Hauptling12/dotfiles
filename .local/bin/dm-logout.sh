#!/usr/bin/env bash
#
# Script name: dm-logout
# Description: Logout, shutdown, reboot or lock screen.
# Dependencies: dmenu, systemd, slock, notify-send
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# License: https://www.gitlab.com/dwt1/dmscripts/LICENSE
# Contributors: Derek Taylor,
#               Simon Ingelsson

# Set with the flags "-e", "-u","-o pipefail" cause the script to fail
# if certain things happen, which is a good thing.  Otherwise, we can
# get hidden bugs that are hard to discover.
set -euo pipefail

# use notify-send if run in dumb term
# TODO: add abillity to control from config.
_out="echo"
if [[ ${TERM} == 'dumb' ]]; then
    _out="notify-send"
fi

output(){
    ${_out} "dm-logout" "$@"
}
DMENU="dmenu -i -l 20 -p"
main() {
    # An array of options to choose.
    declare -a options=(
    "Lock screen"
    "Logout"
    "Kill-X11"
    "Reboot"
    "Shutdown"
    "Suspend"
    "Quit"
    )


    choice=$(printf '%s\n' "${options[@]}" | ${DMENU} 'Shutdown menu:' "${@}")

    # What to do when/if we choose one of the options.
    case $choice in
        'Logout')
            if [[ "$(echo -e "No\nYes" | ${DMENU} "${choice}?" "${@}" )" == "Yes" ]]; then
#                    killall "awesome"
#printf 'Desktop: %s\nSession: %s\n' "$XDG_CURRENT_DESKTOP" "$GDMSESSION"  | awk '!($1="")' | sed 1d | awk '{print "ps aux \| grep " $0}' | parallel | sed 1q  | awk '{print $2}' | awk '{print "kill " $0}' | parallel

#grep \#printf ~/scripts/bash/dmenu/dm-logout.sh  | sed -e 1q  | cut -c 2- | parallel
killall Xorg
            else
                output "User chose not to logout." && exit 1
            fi
            ;;
        'Lock screen')
            # shellcheck disable=SC2154
            slock
            ;;
    'Kill-X11')
	 #   killall Xorg
	    ;;
    'Reboot')
            if [[ "$(echo -e "No\nYes" | ${DMENU} "${choice}?" "${@}" )" == "Yes" ]]; then
                systemctl reboot
            else
                output "User chose not to reboot." && exit 0
            fi
            ;;
        'Shutdown')
            if [[ "$(echo -e "No\nYes" | ${DMENU} "${choice}?" "${@}" )" == "Yes" ]]; then
                systemctl poweroff
            else
                output "User chose not to shutdown." && exit 0
            fi
            ;;
        'Suspend')
            if [[ "$(echo -e "No\nYes" | ${DMENU} "${choice}?" "${@}" )" == "Yes" ]]; then
                systemctl suspend
            else
                output "User chose not to suspend." && exit 0
            fi
            ;;
        'Quit')
            output "Program terminated." && exit 0
        ;;
        # It is a common practice to use the wildcard asterisk symbol (*) as a final
        # pattern to define the default case. This pattern will always match.
        *)
            exit 0
        ;;
    esac

}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
