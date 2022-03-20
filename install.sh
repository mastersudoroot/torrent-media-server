#!/bin/bash

# ----------------------------------
# Colors
# ----------------------------------
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'
###Legacy Defined Colors
ERROR="31m"      # Error message
SUCCESS="32m"    # Success message
WARNING="33m"   # Warning message
INFO="36m"     # Info message
LINK="92m"     # Share Link Message

#Predefined install,do not change!!!
#install_bbr=1
#trojanport="443"
#tcp_fastopen="true"

colorEcho() {
  set +e
  COLOR=$1
  echo -e "\033[${COLOR}${@:2}\033[0m"
}

#System Requirement
if [[ $(id -u) != 0 ]]; then
  colorEcho() $ERROR "Please run this script as root!"
  exit 1
fi

initial() {
set +e
clear
colorEcho $INFO "Check new packages update"
if cat /etc/*release | grep ^NAME | grep -q Ubuntu; then 
dist="ubuntu"
apt update
apt upgrade -y
elif cat /etc/*release | grep ^NAME | grep -q Debian; then 
dist="debian"
apt update
apt upgrade -y
fi
if [[ $dist = debian ]]; then 
dpkg-reconfigure tzdata
apt purge ntp -y
systemctl start systemd-timesyncd
timedatectl
date
sleep 3
elif [[ $dist = ubuntu ]]; then 
dpkg-reconfigure tzdata
systemctl start systemd-timesyncd
timedatectl
date
sleep 3
fi
if [[ $(systemctl is-active caddy) == active ]]; then
systemctl stop caddy
systemctl disable caddy 
fi
if [[ $(systemctl is-active apache2) == active ]]; then
systemctl stop apache2
systemctl disable apache2
fi
if [[ $(systemctl is-active httpd) == active ]]; then
systemctl stop httpd
systemctl disable httpd
fi
}

base() {
set +e
apt update
colorEcho $INFO "Installing all necessary packages"
apt install curl wget git zip unzip tar ufw neofetch -y
clear
}

install() {
# Nginx
wget https://raw.githubusercontent.com/mastersudoroot/torrent-media-server/main/packages/nginx.sh && chmod +x nginx.sh && ./nginx.sh
rm -r nginx.sh

# PHP
wget https://raw.githubusercontent.com/mastersudoroot/torrent-media-server/main/packages/php.sh && chmod +x php.sh && ./php.sh
rm -r php.sh

# Filebrowser
wget https://raw.githubusercontent.com/mastersudoroot/torrent-media-server/main/packages/filebrowser.sh && chmod +x filebrowser.sh && ./filebrowser.sh
rm -r filebrowser.sh

# Qbittorrent
wget https://raw.githubusercontent.com/mastersudoroot/torrent-media-server/main/packages/qbt.sh && chmod qbt.sh && ./qbt.sh
rm -r qbt.sh

# Tracker
wget https://raw.githubusercontent.com/mastersudoroot/torrent-media-server/main/packages/tracker.sh && chmod +x tracker.sh && ./tracker.sh
rm -r tracker.sh

# Jellyfin
wget https://raw.githubusercontent.com/mastersudoroot/torrent-media-server/main/packages/jellyfin.sh && chmod +x jellyfin.sh && ./jellyfin.sh
rm -r jellyfin.sh

# Nginx Config
wget https://raw.githubusercontent.com/mastersudoroot/torrent-media-server/main/packages/nginx-config.sh && chmod +x nginx-config.sh && ./nginx-config.sh
rm -r nginx-config.sh
}

menu() {
colorEcho $INFO "===================="
colorEcho $INFO "TORRENT MEDIA SSRVER"
colorEcho $INFO "===================="
colorEcho $INFO " [1] RUN INSTALL"
colorEcho $INFO " [2] EXIT SCRIPT"
colorEcho $INFO " ENTER OPTION: "
case $option in 
1) initial 
   base
   install
   ;;
2) exit 0
   ;;
esac
}

clear
menu
