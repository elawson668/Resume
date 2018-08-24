#!/bin/bash
# This will create a Raspbian mirror using apt-mirror
# and then set up an NGINX web server to provide it to clients.
# Eric Lawson, 2018

sudo apt-get install apt-mirror nginx

cd /etc/apt/
sed -i 's,# set base_path    /var/spool/apt-mirror,set base_path    /opt/apt-mirror,' mirror.list

sed -i '\|deb http://ftp.us.debian.org/debian unstable main contrib non-free|d' mirror.list
sed -i '\|deb-src http://ftp.us.debian.org/debian unstable main contrib non-free|d' mirror.list

sed -i '\|deb-armhf http://archive.raspbian.org/raspbian stretch main contrib firmware rpi non-free|d' mirror.list
sed -i '\|clean http://archive.raspbian.org/raspbian|d' mirror.list

sed -i '\|deb-armhf http://archive.raspberrypi.org/debian stretch main ui|d' mirror.list
sed -i '\|clean http://archive.raspberrypi.org/debian|d' mirror.list

echo 'deb-armhf http://archive.raspbian.org/raspbian stretch main contrib firmware rpi non-free' >> ./mirror.list
echo 'deb-armhf http://archive.raspberrypi.org/debian stretch main ui' >> ./mirror.list

echo 'clean http://archive.raspbian.org/raspbian' >> ./mirror.list
echo 'clean http://archive.raspberrypi.org/debian' >> ./mirror.list

sudo mkdir -p /opt/apt-mirror
sudo apt-mirror
/opt/apt-mirror/var/clean.sh

cd /opt/apt-mirror/var
touch postmirror.sh

echo '/opt/apt-mirror/var/clean.sh' >> ./postmirror.sh

crontab -r
(crontab -l 2>/dev/null; \
  echo "0 2 * * * /usr/bin/apt-mirror >> /opt/apt-mirror/mirror/archive.raspbian.org/raspbian/apt-mirror.log") | crontab -

cd /etc/nginx/sites-enabled
sed -i 's,/var/www/html,/opt/apt-mirror/mirror,' default
/etc/init.d/nginx restart






