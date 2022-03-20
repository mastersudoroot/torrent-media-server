#!/bin/bash 

domain=$(hostname -f)

rm -rf /etc/nginx/sites-available/*
rm -rf /etc/nginx/sites-enabled/*
rm -rf /etc/nginx/conf.d/*
touch /etc/nginx/conf.d/default.conf
cat > '/etc/nginx/conf.d/default.conf' << EOF
server {
  listen 127.0.0.1:81 fastopen=20 reuseport default_server so_keepalive=on;
  listen 127.0.0.1:82 http2 fastopen=20 reuseport default_server so_keepalive=on;
  server_name $domain _;
  #resolver 127.0.0.1;
  resolver_timeout 10s;
  client_header_timeout 1071906480m;
  lingering_close always;
  ssl_early_data on;
  #if (\$http_user_agent ~* (360|Tencent|MicroMessenger|Maxthon|TheWorld|UC|OPPO|baidu|Sogou|2345|) ) { return 403; }
  #if (\$http_user_agent ~* (wget|curl) ) { return 403; }
  #if (\$http_user_agent = "") { return 403; }
  #if (\$host != "$domain") { return 404; }
  add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
  #add_header X-Cache-Status \$upstream_cache_status;
  location / {
    #proxy_pass http://127.0.0.1:4000/; # Hexo server
    root /usr/share/nginx/hexo/public/; # Hexo public content
    #error_page 404  /404.html;
  }
EOF

echo "    location /jellyfin {" >> /etc/nginx/conf.d/default.conf
echo "        return 302 https://$domain:443/jellyfin/;" >> /etc/nginx/conf.d/default.conf
echo "    }" >> /etc/nginx/conf.d/default.conf
echo "    location /jellyfin/ {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://127.0.0.1:8099/jellyfin/;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass_request_headers on;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Host \$host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forward-Proto https;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-Host \$http_host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Connection \$http_connection;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_buffering off;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
# echo "    location /emby {" >> /etc/nginx/conf.d/default.conf
# echo "        return 302 https://${domain}:443/emby/;" >> /etc/nginx/conf.d/default.conf
# echo "    }" >> /etc/nginx/conf.d/default.conf
# echo "    location /emby/ {" >> /etc/nginx/conf.d/default.conf
# echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
# echo "        proxy_pass http://127.0.0.1:8096/;" >> /etc/nginx/conf.d/default.conf
# echo "        proxy_pass_request_headers on;" >> /etc/nginx/conf.d/default.conf
# echo "        proxy_set_header Host \$host;" >> /etc/nginx/conf.d/default.conf
# echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/default.conf
# echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/default.conf
# echo "        proxy_set_header X-Forward-Proto https;" >> /etc/nginx/conf.d/default.conf
# echo "        proxy_set_header X-Forwarded-Host \$http_host;" >> /etc/nginx/conf.d/default.conf
# echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/default.conf
# echo "        proxy_set_header Connection \$http_connection;" >> /etc/nginx/conf.d/default.conf
# echo "        proxy_buffering off;" >> /etc/nginx/conf.d/default.conf
# echo "        }" >> /etc/nginx/conf.d/default.conf

# echo "    location /speedtest/ {" >> /etc/nginx/conf.d/default.conf
# echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
# echo "        client_max_body_size 0;" >> /etc/nginx/conf.d/default.conf
# echo "        alias /usr/share/nginx/speedtest/;" >> /etc/nginx/conf.d/default.conf
# echo "        http2_push /speedtest/speedtest.js;" >> /etc/nginx/conf.d/default.conf
# echo "        http2_push /speedtest/favicon.ico;" >> /etc/nginx/conf.d/default.conf
echo "        location ~ \.php\$ {" >> /etc/nginx/conf.d/default.conf
echo "        fastcgi_split_path_info ^(.+\.php)(/.+)\$;" >> /etc/nginx/conf.d/default.conf
echo "        fastcgi_param HTTPS on;" >> /etc/nginx/conf.d/default.conf
echo "        fastcgi_param SCRIPT_FILENAME \$request_filename;" >> /etc/nginx/conf.d/default.conf
echo "        include fastcgi_params;" >> /etc/nginx/conf.d/default.conf
echo "        fastcgi_pass   unix:/run/php/php8.0-fpm.sock;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf

echo "    location /qbt/ {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass              http://127.0.0.1:8080/;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header        X-Forwarded-Host        \$http_host;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf

echo "    location /file/ {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://127.0.0.1:8081/;" >> /etc/nginx/conf.d/default.conf
echo "        client_max_body_size 0;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf

echo "    location /tracker/ {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        index index.html;" >> /etc/nginx/conf.d/default.conf
echo "        alias /usr/share/nginx/tracker/;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
echo "    location /tracker_stats/ {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://127.0.0.1:6969/;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
echo "    location ~ ^/announce$ {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://127.0.0.1:6969;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf

chown -R nginx:nginx /usr/share/nginx/
systemctl restart nginx
