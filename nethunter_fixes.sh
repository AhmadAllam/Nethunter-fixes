#!/bin/bash
clear
red="\e[31m"
green="\e[32m"
yelo="\e[1;33m"
cyn="\e[36m"
nc="\e[0m"

loopS () {
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep 0.04
    done
}

loopF () {
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep 0.02
    done
}

mycat () {
    echo -e "${yelo} "
    cat << "caty"
,_     _
 |\_,-~/
 / _  _ |    ,--.
(  @  @ )   / ,-'
 \  _T_/-._( (
 /         `. \
|         _  \ |
 \ \ ,  /      |
  || |-_\__   /
 ((_/`(____,-'
_____________________
caty
}

banner () {
    text="Nethunter Fixing Script by "
    loopS
    printf "${nc}@AhmadAllam${nc}\n"
}

chroot_or_termux () {
    if [ -d "/data/data/com.termux/files/home" ]; then
        echo " "
        echo "sorry this script for nethunter chroot only"
        exit
    fi
}

menu () {
    echo ""
    echo ""
    echo -e " [1]:${cyn}fixing internet ${nc} "
    echo -e " [2]:${cyn}fixing apt key ${nc} "
    echo -e " [3]:${cyn}fixing sources ${nc} "
    echo -e " [4]:${cyn}fixing vnc & kex ${nc} "
    echo -e " [5]:${cyn}install NH main Tools ${nc} "
    echo -e " [0]:${cyn}about & help ${nc} "
    echo -e ""
    echo ""

    printf "${yelo}What do you want${nc} : "
    read -p "" entry

    case $entry in
        1 | 01)
            clear
            check_group
            text="Fixed , now test (apt update or ping )"
            echo -e "${green} "
            loopF
            echo -e "${nc} "
            menu
            ;;

        2 | 02)
            clear
            fix_apt
            menu
            ;;

        3 | 03)
            clear
            check_src
            menu
            ;;

        4 | 04)
            clear
            fix_vnc
            text="Fixed , now try vnc or kex"
            echo -e "${green} "
            loopF
            echo -e "${nc} "
            menu
            ;;

        5 | 05)
            clear
            installing
            text="installation successfull , please restart chroot :)"
            echo -e "${green} "
            loopF
            echo -e "${nc} "
            menu
            ;;

        0 | 00)
            clear
            cols=$(tput cols)
            text="help in my GitHub :)"
            printf "%*s\n" $(((${#text} + cols) / 2)) "${text}"
            link="https://github.com/AhmadAllam/Nethunter-fixes"
            printf "%*s\n" $(((${#link} + cols) / 2)) "${link}"
            menu
            ;;

        *)
            clear
            echo -e "${red} "
            text="oops, looks like you don't want anything."
            loopF
            echo -e "${nc} "
            menu
            ;;
    esac
}

fix_internet () {
    group_inet="inet:x:3003:root"
    group_net_raw="net_raw:x:3004:root"
    apt_sandbox="APT::Sandbox::User \"root\";"
    group_file="/etc/group"
    apt_conf_file="/etc/apt/apt.conf.d/01-android-nosandbox"

    local group_file_content
    group_file_content=$(cat "$group_file" 2>/dev/null)

    local apt_conf_file_content
    if [ -f "$apt_conf_file" ]; then
        apt_conf_file_content=$(cat "$apt_conf_file" 2>/dev/null)
    fi

    if echo "$group_file_content" | grep -q "$group_inet" && \
       echo "$group_file_content" | grep -q "$group_net_raw" && \
       echo "$apt_conf_file_content" | grep -q "$apt_sandbox"; then
        text="Internet settings already fixed."
        echo -e "${green} "
        loopF
        echo -e "${nc} "
    else
        groupadd -g 3003 aid_inet 2>/dev/null
        usermod -G nogroup -g aid_inet _apt
        echo "$apt_sandbox" > "$apt_conf_file"

        if ! echo "$group_file_content" | grep -q "$group_inet"; then
            echo "$group_inet" >> "$group_file"
        fi

        if ! echo "$group_file_content" | grep -q "$group_net_raw"; then
            echo "$group_net_raw" >> "$group_file"
        fi

        text="Internet settings fixed successfully."
        echo -e "${green} "
        loopF
        echo -e "${nc} "
    fi
}

fix_apt () {
    key_id="7D8D0BF6"
    if apt-key list | grep -q "$key_id"; then
        text="Key already exists."
        echo -e "${green} "
        loopF
        echo -e "${nc} "
    else
        apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys "$key_id"
        text="Key added successfully."
        echo -e "${green} "
        loopF
        echo -e "${nc} "
    fi
}

fix_sources () {
    search_for="deb http://http.kali.org/kali kali-rolling main contrib non-free"
    file="/etc/apt/sources.list"

    local file_content
    file_content=$(cat "$file" 2>/dev/null)

    if echo "$file_content" | grep -q "$search_for"; then
        text="Sources already exist."
        echo -e "${green} "
        loopF
        echo -e "${nc} "
    else
        echo " " >> "$file"
        echo "$search_for" >> "$file"
        echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> "$file"
        text="Sources added successfully."
        echo -e "${green} "
        loopF
        echo -e "${nc} "
    fi
}

fix_vnc () {
    sudo wget -O /root/.vnc/xstartup https://gitlab.com/kalilinux/packages/kali-win-kex/-/raw/kali/master/usr/lib/win-kex/xstartup
    sleep 1
    apt-get update && apt-get -y upgrade && apt-get -y full-upgrade
    sleep 1
    chmod +x ~/.vnc/xstartup
    chmod +x /home/kali/.vnc/xstartup
    echo " "
}

installing () {
    apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade
    echo " "

    echo -e "${cyn}Installing Python and pip...${nc}"
    apt-get -y install python3 python3-pip
    echo -e "${green}Python and pip installation finished.${nc}"
    echo " "

    if [ -f "tools.txt" ]; then
        echo -e "${cyn}Installing main Nethunter tools...${nc}"
        while IFS= read -r pkg || [ -n "$pkg" ]; do
            apt-get -y install "$pkg"
        done < "tools.txt"
        echo -e "${green}Main Nethunter tools installation finished.${nc}"
    else
        echo -e "${red}File tools.txt not found! Skipping main tools installation.${nc}"
    fi
    echo " "

    if [ -f "pip.txt" ]; then
        echo -e "${cyn}Installing Python libraries from pip.txt...${nc}"
        while IFS= read -r lib || [ -n "$lib" ]; do
            pip install "$lib" --break-system-packages
        done < "pip.txt"
        echo -e "${green}Python libraries installation finished.${nc}"
    else
        echo -e "${red}File pip.txt not found! Skipping Python libraries installation.${nc}"
    fi
    echo " "

    apt-get -y autoremove
    echo " "
}

check_group () {
    search_for="inet:x:3003:root"
    file="/etc/group"

    local file_content
    file_content=$(cat "$file" 2>/dev/null)

    if echo "$file_content" | grep -q "$search_for"; then
        text="already Fixed bro ;)"
        echo -e "${green} "
        loopF
        echo -e "${nc} "
        menu
    else
        fix_internet
    fi
}

check_src () {
    search_for="deb http://http.kali.org/kali kali-rolling main contrib non-free"
    file="/etc/apt/sources.list"

    local file_content
    file_content=$(cat "$file" 2>/dev/null)

    if echo "$file_content" | grep -q "$search_for"; then
        text="already Fixed bro ;)"
        echo -e "${green} "
        loopF
        echo -e "${nc} "
        menu
    else
        fix_sources
    fi
}

reset_color() {
    tput sgr0
    tput op
}

goodbye () {
    echo -e "${red} "
    text="thanks & goodbye."
    loopF
    echo -e "${nc} "
    reset_color
    exit
}
trap goodbye INT

mycat
banner
chroot_or_termux
menu
