#!/bin/bash

filever=$(curl -s https://api.github.com/repos/filebrowser/filebrowser/releases/latest | grep -o '"tag_name": ".*"' | sed 's/"//g' | sed 's/tag_name: //g')

curl -LO https://github.com/filebrowser/filebrowser/releases/download/${filever}/linux-amd64-filebrowser.tar.gz
tar -xvf linux-amd64-filebrowser.tar.gz
cp -f filebrowser /usr/local/bin/filebrowser
rm linux-amd64-filebrowser.tar.gz
rm CHANGELOG.md LICENSE README.md filebrowser

cat > '/etc/systemd/system/filebrowser.service' << EOF
[Unit]
Description=filebrowser browser
Documentation=https://github.com/filebrowser/filebrowser
After=network.target

[Service]
User=root
Group=root
RemainAfterExit=yes
ExecStart=/usr/local/bin/filebrowser -r / -d /etc/filebrowser/database.db -b /file/ -p 8081
ExecReload=/usr/bin/kill -HUP \$MAINPID
ExecStop=/usr/bin/kill -s STOP \$MAINPID
LimitNOFILE=65536
RestartSec=3s
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
mkdir /etc/filebrowser/
systemctl daemon-reload
systemctl enable filebrowser
systemctl restart filebrowser
chmod -R 755 /etc/filebrowser/
cd
