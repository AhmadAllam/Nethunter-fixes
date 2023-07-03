#!/bin/bash
clear
#colors
red="\e[31m"
green="\e[32m"
yelo="\e[1;33m"
cyn="\e[36m"
nc="\e[0m"

#function_loop
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
#function_my cat
mycat () {
echo -e "${yelo} "
cat << "caty" 
,_     _
 |\\_,-~/
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

#function_banner
banner () {
text="Nethunter Fixing Script by "
loopS
printf "${nc}@AhmadAllam${nc}"
}

#function_check termux
chroot_or_termux () {
if [ -d "/data/data/com.termux/files/home" ]; then
    echo " "
    echo "sorry this script for nethunter chroot only"
    exit
fi
}

#function_menu
menu () {
echo ""
echo ""
echo -e " [1]:${cyn}fixing internet ${nc} "
echo -e " [2]:${cyn}fixing apt key ${nc} "
echo -e " [3]:${cyn}fixing sources ${nc} "
echo -e " [4]:${cyn}fixing vnc & kex ${nc} "
echo -e " [5]:${cyn}install NH main Tools ${nc} "
echo -e " [6]:${cyn}run kali in termux${nc} "
echo -e " [0]:${cyn}about & help ${nc} "
echo -e ""
echo ""

#choice
printf "${yelo}What do you want${nc} : "
read -p "" entry

#function_fix internet
fix_internet () {
groupadd -g 3003 aid_inet && usermod -G nogroup -g aid_inet _apt
echo 'APT::Sandbox::User "root";' > /etc/apt/apt.conf.d/01-android-nosandbox
echo " " >>/etc/group
echo inet:x:3003:root >>/etc/group
echo net_raw:x:3004:root >>/etc/group
echo " "
}

#function_fix apt
fix_apt () {
apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 7D8D0BF6
echo " "
}

#function_fix sources
fix_sources () {
echo " " >>/etc/apt/sources.list
echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" >>/etc/apt/sources.list
echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >>/etc/apt/sources.list
echo " "
}

#function_fix vnc
fix_vnc () {
sudo wget -O /root/.vnc/xstartup https://gitlab.com/kalilinux/packages/kali-win-kex/-/raw/kali/master/usr/lib/win-kex/xstartup
sleep 1
apt update && apt -y upgrade && apt -y full-upgrade
sleep 1
chmod +x ~~/.vnc/xstartup
chmod +x /home/kali/.vnc/xstartup
echo " "
}

#function_installing
installing () {
apt update && apt -y upgrade && apt -y dist-upgrade
echo " "
pkgs=(default-jdk nodejs npm mdk3 mdk4 hydra php iptables macchanger hping3 nmap netcat-traditional curl wget git python3 python2 python2-minimal python-is-python3 2to3 python3-pip ettercap-text-only zip unzip zsh-autosuggestions zsh-syntax-highlighting)
for pkg in "${pkgs[@]}";
do
apt -y install $pkg
done
apt -y autoremove
echo " "
}

#function_termux2kali
termux_kali () {
printf "you can replace current Nethunter apk with
material Nethunter for full termux support
without errors you can download latest mod
version from my telegram channel"
}

#function_Check group file
check_group () {
search_for="inet:x:3003:root"
file="/etc/group"

if grep -q "$search_for" "$file"; then
    text="already Fixed bro ;)"
      echo -e "${green} "
      loopF
      echo -e "${nc} "
      menu
else
    fix_internet
fi
}

#function_Check source file
check_src () {
search_for="deb http://http.kali.org/kali kali-rolling main contrib non-free"
file="/etc/apt/sources.list"

if grep -q "$search_for" "$file"; then
    text="already Fixed bro ;)"
      echo -e "${green} "
      loopF
      echo -e "${nc} "
      menu
else
    fix_sources
fi
}

#cases
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
      text="Fixed , now try apt update or apt upgrade"
      echo -e "${green} "
      loopF
      echo -e "${nc} "
      menu
      ;;
	
	3 | 03)
	  clear
      check_src
      text="Fixed , now try apt update or apt dist-upgrade"
      echo -e "${green} "
      loopF
      echo -e "${nc} "
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
	
	6 | 06)
	  clear
      termux_kali
      text=" https://github.com/AhmadAllam?tab=repositories   "
      echo -e " \n ${green} "
      loopF
      echo -e "${nc} "
      menu
      ;;
	
	0 | 00)
	clear
echo -e "${green} "
text="               ««««<About me>»»»»"
loopF
echo -e "${nc} "
printf "\n"
grep -A 2 "Written" help.txt
#################################
echo -e "${green} "
text="_______Nethunter terminal commands_______"
loopF
echo -e "${nc} "
printf "\n"
grep -A 31 "1:fixing internet" help.txt
printf "\n"
################################
echo -e "${yelo} "
helpo=$(grep -A 20 "________________________" help.txt)
for (( i=0; i<${#helpo}; i++ )); do
    echo -n "${helpo:$i:1}"
    sleep 0.01
done
echo -e "${nc} "
printf "\n \n \n \n"
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

#function_reset
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
}

#function_goodbye
goodbye () {
echo -e "${red} "
      text="thanks & goodbye."
      loopF
      echo -e "${nc} "
      reset_color
      exit
}
trap goodbye INT

##call functions
mycat
banner
chroot_or_termux
menu
