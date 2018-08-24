# Eric Lawson, 2018-08-15
#!/bin/bash

# Update license scripts and code
echo "Updating license scripts"
# Pull from repository with licenses (omitted)

# clean directories
./cleanAll.sh

# intall pre-requisities
sudo apt-get update
sudo apt-get -y install nginx

CWD="$(pwd)"
cd /etc/nginx/sites-enabled
sudo sed -i 's,/var/www/html,'$CWD'/Reports,' default
cd $CWD
sudo /etc/init.d/nginx restart

# Update Debian packages
echo "Updating packages"
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

./runAll.sh

IP=`hostname -I`
echo "Your report is located at http://$IP"
