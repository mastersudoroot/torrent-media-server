#!/bin/bash

apt install -y apt-transport-https
curl --retry 5 -LO https://github.com/MediaBrowser/Emby.Releases/releases/download/4.6.7.0/emby-server-deb_4.6.7.0_amd64.deb
dpkg -i emby-server-deb_4.6.7.0_amd64.deb
rm emby-server-deb_4.6.7.0_amd64.deb

cat /etc/emby-server.conf | grep media &> /dev/null

if [[ $? != 0 ]]; then
systemctl stop emby-server
sed -i "s/EMBY_DATA=/EMBY_DATA=\/data\/media\//g" /etc/emby-server.conf
sed -i "s/User=emby/User=root/g" /lib/systemd/system/emby-server.service
systemctl daemon-reload
fi
cd /root
systemctl restart emby-server
