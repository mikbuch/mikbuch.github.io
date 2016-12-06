#!/bin/bash

# Check if script was run as root.
if [ "$EUID" -ne 0 ]; then
    printf "\nPlease run as root\n\n"
    exit 0
fi

device="wlp1s0"

ip link set $device up

printf "\nSearching for the networks ..."
networks_available=$(iw wlp1s0 scan | grep SSID | sed -e "s/^[ \t]*SSID: //")
printf " networks available:\n"
printf "%s " ${networks_available}
printf "\n"

interfaces_saved=$(ls -1 /etc/netctl | grep $device | sed -r s/$device-//)
printf "\nInterfaces remembered in directory /etc/netctl\n"
printf "%s " ${interfaces_saved}
printf "\n"

init_wd=$(pwd)
network_matched="false"

printf "\nMatching networks ..."

for avail in $networks_available
do
    for remem in $interfaces_saved
    do
        if [ $avail = $remem ]; then
            network_matched="true"
            printf " network === $avail === matched! \n"
            cd /etc/netctl
            printf "Connecting ..."
            netctl start $device-$avail
            printf " succesfully connected.\n"
            printf "\nExiting the program ... \n\n"
            printf ""
            break
        fi
    done

    if [ $network_matched = "true" ]; then
        break
    fi
done

if [ $network_matched = "false" ]; then
    printf "... no networks matched."
    printf "Please find a new one with <<wifi-menu>> command or check your connection."
fi

cd $init_wd

exit 0
