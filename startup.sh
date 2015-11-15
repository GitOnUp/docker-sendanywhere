#!/bin/bash

mkdir -p /var/run/sshd

# create an ubuntu user
# PASS=`pwgen -c -n -1 10`
PASS=ubuntu
# echo "Username: ubuntu Password: $PASS"
id -u ubuntu &>/dev/null || useradd --create-home --shell /bin/bash --user-group --groups adm,sudo ubuntu
echo "ubuntu:$PASS" | chpasswd
mkdir -p /home/ubuntu/.local/share/Estmob/Send\ Anywhere/config
mv /tmp/config.ini /home/ubuntu/.local/share/Estmob/Send\ Anywhere/config
mkdir -p /home/ubuntu/.config/autostart
cp /usr/share/applications/sendanywhere.desktop /home/ubuntu/.config/autostart
mkdir -p /home/ubuntu/bin
mv /tmp/process_uploads.sh /home/ubuntu/bin
chown ubuntu:ubuntu -R /home/ubuntu
crontab -u ubuntu /tmp/ubuntu_crontab

cd /web && ./run.py > /var/log/web.log 2>&1 &
nginx -c /etc/nginx/nginx.conf
exec /usr/bin/supervisord -n
