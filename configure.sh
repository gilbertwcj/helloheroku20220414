#!/bin/sh
# generate configuration
# Download and install
config_path=$PROTOCOL"_ws_tls.json"
mkdir /tmp/software
curl -L -H "Cache-Control: no-cache" -o /tmp/software/server.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/software/server.zip -d /tmp/software
install -m 755 /tmp/software/server /usr/local/bin/server
install -m 755 /tmp/software/serverctl /usr/local/bin/servertl
# Remove temporary directory
rm -rf /tmp/software
rm -rf server.zip
# V2Ray new configuration
install -d /usr/local/etc/server
envsubst '\$UUID,\$WS_PATH' < $config_path > /usr/local/etc/server/config.json
# MK TEST FILES
mkdir /opt/test
cd /opt/test
dd if=/dev/zero of=100mb.bin bs=100M count=1
dd if=/dev/zero of=10mb.bin bs=10M count=1
# Run V2Ray
/usr/local/bin/server -config /usr/local/etc/server/config.json &
# Run nginx
/bin/bash -c "envsubst '\$PORT,\$WS_PATH' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'