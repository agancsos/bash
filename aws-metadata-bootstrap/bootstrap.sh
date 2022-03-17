#!/bin/bash
###############################################################################
# Name        : bootstrap.sh                                                  #
# Author      : Abel Gancsos                                                  #
# Version     : v. 1.0.0.0                                                    #
# Description : AWS bootstrap script to generate a metadata report.           #
###############################################################################
WWW_PATH=/var/www/html
PAGE_TITLE="Cloud Guru Lab EC2"
PACKAGE_MANAGER=zypper
PLATFORM=
while getopts "p:m:" option; do
	case $option in
		p) WWW_PATH=$OPTARG ;;
		m) PACKAGE_MANAGER=$OPTARG ;;
		*) ;;
	esac
done

PLATFORM=$(uname -s)
if [ $PLATFORM != "Linux" ]; then
	printf "\033[31;1mSystem is not Lnix... ($PLATFORM)\033[m\n"
else
	PLATFORM=$(cat /etc/os-release | grep -i pretty_name | cut -f 2 -d =)
	if [[ $PLATFORM == *"Debian"* ]] || [[ $PLATFORM == *"Ubuntu"* ]]; then
		PACKAGE_MANAGER=apt
	elif [[ $PLATFORM == *"Red"* ]] || [[ $PLATFORM == *"CentOS"* ]] || [[ $PLATFORM == *"AWS Linux"* ]]; then
		PACKAGE_MANAGER=yum
	fi
	sudo $PACKAGE_MANAGER update
	sudo $PACKAGE_MANAGER upgrade -y
	sudo $PACKAGE_MANAGER install -y apache2 curl unzip
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	echo "<html><head><title>$PAGE_TITLE</title><style>" > "$WWW_PATH/index.html"
	echo "html { width: 100%; height: 100%; }" >> "$WWW_PATH/index.html"
	echo "body { width: 100%; height: 100%; }table { width: 100%; border-collapse: collapse; border: 2px solid black; }" >> "$WWW_PATH/index.html"
	echo "table th, td { text-align: left; border: 2px solid black; }</style></head>" >> "$WWW_PATH/index.html"
	echo "<body><table><tr><th>Availability Zone</th><th>Instance ID</th><th>Public IP</th><th>Private IP Address</th></tr>" >> "$WWW_PATH/index.html"
	ZONE_NAME=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
	INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
	PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
	PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
	echo "<tr><td>$ZONE_NAME</td><td>$INSTANCE_ID</td><td>$PUBLIC_IP</td><td>$PRIVATE_IP</td></tr></table></body></html>" >> "$WWW_PATH/index.html"
fi
exit 0

