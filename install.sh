#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
ENDCOLOR="\e[0m"

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
exit
fi
ENV_FILE="/var/www/html/app/.env"
COPY_FILE="/var/www/html/.env_copy"

if [ -f "$ENV_FILE" ]; then
  cp "$ENV_FILE" "$COPY_FILE"
  chmod 644 /var/www/html/.env_copy
fi
# List of supported distributions
#supported_distros=("Ubuntu" "Debian" "Fedora" "CentOS" "Arch")
supported_distros=("Ubuntu")
# Get the distribution name and version
if [[ -f "/etc/os-release" ]]; then
    source "/etc/os-release"
    distro_name=$NAME
    distro_version=$VERSION_ID
else
    echo "Unable to determine distribution."
    exit 1
fi
# Check if the distribution is supported
if [[ " ${supported_distros[@]} " =~ " ${distro_name} " ]]; then
    echo "Your Linux distribution is ${distro_name} ${distro_version}. It is supported."
    : #no-op command
else
    # Print error message in red
    echo -e "\e[31mYour Linux distribution (${distro_name} ${distro_version}) is not currently supported.\e[0m"
    exit 1
fi


# php7.x is End of life https://www.php.net/supported-versions.php ubuntu bellow 20 is not supported by php8.1 in 2023
if [ "$(uname)" == "Linux" ]; then
    version_info=$(lsb_release -rs)
    # Check if it's Ubuntu and version is below 20
    if [ "$(lsb_release -is)" == "Ubuntu" ] && [ "$(echo "$version_info < 20" | bc)" -eq 1 ]; then
        echo "This Script is using php8.1 and only supported in ubuntu 20 and above"
        exit
    fi
fi


userDirectory="/home"
for user in $(ls $userDirectory); do
if [ "$user" == "f4cabs" ]; then
sudo killall -u f4cabs & deluser f4cabs
fi
done

sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
sed -i 's/#Banner none/Banner \/root\/banner.txt/g' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
port=$(grep -oE 'Port [0-9]+' /etc/ssh/sshd_config | cut -d' ' -f2)

# Check if MySQL is installed
if dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep -q "install ok installed"; then
adminuser=$(mysql -N -e "use XPanel_plus; select username from admins where permission='admin';")
adminpass=$(mysql -N -e "use XPanel_plus; select username from admins where permission='admin';")
ssh_tls_port=$(mysql -N -e "use XPanel_plus; select tls_port from settings where id='1';")
fi

folder_path_cp="/var/www/html/cp"
if [ -d "$folder_path_cp" ]; then
    rm -rf /var/www/html/cp
fi
folder_path_app="/var/www/html/app"
if [ -d "$folder_path_app" ]; then
    rm -rf /var/www/html/app
fi

if [ -n "$ssh_tls_port" -a "$ssh_tls_port" != "NULL" ]
then
     sshtls_port=$ssh_tls_port
else
     sshtls_port=444
fi
if test -f "/var/www/xpanelport"; then
domainp=$(cat /var/www/xpanelport | grep "^DomainPanel")
sslp=$(cat /var/www/xpanelport | grep "^SSLPanel")
xpo=$(cat /var/www/xpanelport | grep "^Xpanelport")
xport=$(echo "$xpo" | sed "s/Xpanelport //g")
dmp=$(echo "$domainp" | sed "s/DomainPanel //g")
dmssl=$(echo "$sslp" | sed "s/SSLPanel //g")
else
xport=""
dmp=""
dmssl=""
fi

echo -e "${YELLOW}************ Select MadoPanel Version ************"
echo -e "${GREEN}  1)MadoPanel v3.8.0"
echo -e "${GREEN}  1)MadoPanel v3.7.9"
echo -e "${GREEN}  2)MadoPanel v3.7.8"
echo -e "${GREEN}  3)MadoPanel v3.7.7"
echo -e "${GREEN}  4)MadoPanel v3.7.6"
echo -ne "${GREEN}\nSelect Version : ${ENDCOLOR}" ;read n
if [ "$n" != "" ]; then
if [ "$n" == "1" ]; then
linkd=https://api.github.com/repos/vahidazimi/madopanel/releases/tags/v3-8-0
fi
if [ "$n" == "2" ]; then
linkd=https://api.github.com/repos/vahidazimi/madopanel/releases/tags/v3-7-9
fi
if [ "$n" == "3" ]; then
linkd=https://api.github.com/repos/vahidazimi/madopanel/releases/tags/v3-7-8
fi
if [ "$n" == "4" ]; then
linkd=https://api.github.com/repos/vahidazimi/madopanel/releases/tags/37
fi
if [ "$n" == "5" ]; then
linkd=https://api.github.com/repos/vahidazimi/madopanel/releases/tags/xpanel
fi
else
linkd=https://api.github.com/repos/vahidazimi/madopanel/releases/tags/v3-7-9
fi

echo -e "\nPlease input IP Server"
printf "IP: "
read ip
if [ -n "$ip" -a "$ip" == " " ]; then
echo -e "\nPlease input IP Server"
printf "IP: "
read ip
fi
clear
adminusername=admin
echo -e "\nPlease input Panel admin user."
printf "Default user name is \e[33m${adminusername}\e[0m, let it blank to use this user name: "
read usernametmp
if [[ -n "${usernametmp}" ]]; then
adminusername=${usernametmp}
fi


# Function to generate random uppercase character
function random_uppercase {
    echo $((RANDOM%26+65)) | awk '{printf("%c",$1)}'
}

# Function to generate random lowercase character
function random_lowercase {
    echo $((RANDOM%26+97)) | awk '{printf("%c",$1)}'
}

# Function to generate random digit
function random_digit {
    echo $((RANDOM%10))
}

# Generate a complex password
password=""
password="${password}$(random_uppercase)"
password="${password}$(random_uppercase)"
password="${password}$(random_uppercase)"
password="${password}$(random_uppercase)"
password="${password}$(random_digit)"
password="${password}$(random_digit)"
password="${password}$(random_digit)"
password="${password}$(random_digit)"
password="${password}$(random_lowercase)"
password="${password}$(random_lowercase)"
password="${password}$(random_lowercase)"

adminpassword=${password}


echo -e "\nPlease input Panel admin password."
printf "Randomly generated password is \e[33m${adminpassword}\e[0m, leave it blank to use this random password : "
read passwordtmp
if [[ -n "${passwordtmp}" ]]; then
adminpassword=${passwordtmp}
fi
if [ "$dmp" != "" ]; then
defdomain=$dmp
else

defdomain=$ip
fi

if [ "$dmssl" == "True" ]; then
protcohttp=https

else
protcohttp=http
fi
ipv4=$ip
sudo sed -i '/www-data/d' /etc/sudoers &
wait
sudo sed -i '/apache/d' /etc/sudoers &
wait

if command -v apt-get >/dev/null; then

sudo NEETRESTART_MODE=a apt-get update --yes
sudo apt-get -y install software-properties-common
apt-get install -y stunnel4 && apt-get install -y cmake && apt-get install -y screenfetch && apt-get install -y openssl
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
apt-get install apache2 zip unzip net-tools curl mariadb-server -y
apt-get install php php-cli php-mbstring php-dom php-pdo php-mysql -y
apt-get install npm -y
sudo apt-get install coreutils
wait
phpv=$(php -v)
if [[ $phpv == *"8.1"* ]]; then

apt autoremove -y
  echo "PHP Is Installed :)"
else
rm -fr /etc/php/7.4/apache2/conf.d/00-ioncube.ini
sudo apt-get purge '^php7.*' -y
apt remove php* -y
apt remove php -y
apt autoremove -y
apt install php8.1 php8.1-mysql php8.1-xml php8.1-curl cron -y
fi
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
    
#Banner 
cat << EOF > /root/banner.txt
Connect To Server
EOF
#Configuring stunnel
sudo mkdir /etc/stunnel
cat << EOF > /etc/stunnel/stunnel.conf
 cert = /etc/stunnel/stunnel.pem
 [openssh]
 accept = $sshtls_port
 connect = 0.0.0.0:$port
EOF

echo "=================  MadoPanel OpenSSL ======================"
country=ID
state=Semarang
locality=XPanel
organization=hidessh
organizationalunit=HideSSH
commonname=hidessh.com
email=admin@hidessh.com
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart
  
if test -f "/var/www/xpanelport"; then
echo "File exists xpanelport"
else
touch /var/www/xpanelport
fi
link=$(sudo curl -Ls "$linkd" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')
sudo wget -O /var/www/html/update.zip $link
sudo unzip -o /var/www/html/update.zip -d /var/www/html/ &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/adduser' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/userdel' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/passwd' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/curl' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/kill' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/killall' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/rm' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/crontab' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysqldump' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/pgrep' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/local/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/netstat' | sudo EDITOR='tee -a' visudo &
wait
sudo a2enmod rewrite
wait
sudo service apache2 restart
wait
sudo systemctl restart apache2
wait
sudo service apache2 restart
wait
sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf &
wait
sudo service apache2 restart
wait
clear
# Random port number generator to prevent xpanel detection by potential attackers
randomPort=""
# Check if $RANDOM is available in the shell
if [ -z "$RANDOM" ]; then
  # If $RANDOM is not available, use a different random number generation method
  random_number=$(od -A n -t d -N 2 /dev/urandom | tr -d ' ')
else
  # Generate a random number between 0 and 63000 using $RANDOM
  random_number=$((RANDOM % 63001))
fi

# Add 2000 to the random number to get a range between 2000 and 65000
randomPort=$((random_number + 2000))

# Use port 8081 if the random_number is zero (in case $RANDOM was not available and port 8081 was chosen)
if [ "$random_number" -eq 0 ]; then
  randomPort=8081
fi


echo -e "\nPlease input Panel admin Port, or leave blank to use randomly generated port"
printf "Random port \033[33m$randomPort:\033[0m "
read porttmp
if [[ -n "${porttmp}" ]]; then
#Get the server port number from my settings file
serverPort=${porttmp}
serverPortssl=$((serverPort+1))
echo $serverPort
else
serverPort=$randomPort
serverPortssl=$((serverPort+1))
echo $serverPort
fi
if [ "$dmssl" == "True" ]; then
sshttp=$((serverPort+1))
else
sshttp=$serverPort
fi
##Get just the port number from the settings variable I just grabbed
serverPort=${serverPort##*=}
##Remove the "" marks from the variable as they will not be needed
serverPort=${serverPort//'"'}
echo "<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/example
    ErrorLog /error.log
    CustomLog /access.log combined
    <Directory '/var/www/html/example'>
    AllowOverride All
    </Directory>
</VirtualHost>

<VirtualHost *:$serverPort>
    # The ServerName directive sets the request scheme, hostname and port that
    # the server uses to identify itself. This is used when creating
    # redirection URLs. In the context of virtual hosts, the ServerName
    # specifies what hostname must appear in the request's Host: header to
    # match this virtual host. For the default virtual host (this file) this
    # value is not decisive as it is used as a last resort host regardless.
    # However, you must set it for any further virtual host explicitly.
    #ServerName www.example.com

    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/cp

    # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
    # error, crit, alert, emerg.
    # It is also possible to configure the loglevel for particular
    # modules, e.g.
    #LogLevel info ssl:warn

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    # For most configuration files from conf-available/, which are
    # enabled or disabled at a global level, it is possible to
    # include a line for only one particular virtual host. For example the
    # following line enables the CGI configuration for this host only
    # after it has been globally disabled with "a2disconf".
    #Include conf-available/serve-cgi-bin.conf
    <Directory '/var/www/html/cp'>
    AllowOverride All
    </Directory>

</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet" > /etc/apache2/sites-available/000-default.conf
wait
##Replace 'Virtual Hosts' and 'List' entries with the new port number
sudo  sed -i.bak 's/.*NameVirtualHost.*/NameVirtualHost *:'$serverPort'/' /etc/apache2/ports.conf
echo "Listen 80
Listen $serverPort
<IfModule ssl_module>
    Listen $serverPortssl
    Listen 443
</IfModule>

<IfModule mod_gnutls.c>
    Listen $serverPortssl
    Listen 443
</IfModule>" > /etc/apache2/ports.conf
echo '#Xpanel' > /var/www/xpanelport
sudo sed -i -e '$a\'$'\n''Xpanelport '$serverPort /var/www/xpanelport
wait
##Restart the apache server to use new port
sudo /etc/init.d/apache2 reload
sudo service apache2 restart
chown www-data:www-data /var/www/html/cp/* &
wait
systemctl restart mariadb &
wait
systemctl enable mariadb &
wait
sudo phpenmod curl
PHP_INI=$(php -i | grep /.+/php.ini -oE)
sed -i 's/extension=intl/;extension=intl/' ${PHP_INI}
wait
po=$(cat /etc/ssh/sshd_config | grep "^Port")
port=$(echo "$po" | sed "s/Port //g")

systemctl restart httpd
systemctl enable httpd
systemctl enable stunnel4
systemctl restart stunnel4wait
fi
bash <(curl -Ls https://raw.githubusercontent.com/xpanel-cp/Nethogs-Json-main/master/install.sh --ipv4)
mysql -e "create database XPanel_plus;" &
wait
mysql -e "CREATE USER '${adminusername}'@'localhost' IDENTIFIED BY '${adminpassword}';" &
wait
mysql -e "GRANT ALL ON *.* TO '${adminusername}'@'localhost';" &
wait
mysql -e "ALTER USER '${adminusername}'@'localhost' IDENTIFIED BY '${adminpassword}';" &
wait
sed -i "s/DB_USERNAME=.*/DB_USERNAME=$adminusername/g" /var/www/html/app/.env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$adminpassword/g" /var/www/html/app/.env
cd /var/www/html/app
php artisan migrate
if [ -n "$adminuser" -a "$adminuser" != "NULL" ]
then
 mysql -e "USE XPanel_plus; UPDATE admins SET username = '${adminusername}' where permission='admin';"
 mysql -e "USE XPanel_plus; UPDATE admins SET password = '${adminpassword}' where permission='admin';"
 mysql -e "USE XPanel_plus; UPDATE settings SET ssh_port = '${port}' where id='1';"
else
mysql -e "USE XPanel_plus; INSERT INTO admins (username, password, permission, credit, status) VALUES ('${adminusername}', '${adminpassword}', 'admin', '', 'active');"
home_url=$protcohttp://${defdomain}:$sshttp
mysql -e "USE XPanel_plus; INSERT INTO settings (ssh_port, tls_port, t_token, t_id, language, multiuser, ststus_multiuser, home_url) VALUES ('${port}', '444', '', '', '', 'active', '', '${home_url}');"
fi
sed -i "s/PORT_SSH=.*/PORT_SSH=$port/g" /var/www/html/app/.env
sudo chown -R www-data:www-data /var/www/html/app
crontab -r
wait
multiin=$(echo "$protcohttp://${defdomain}:$sshttp/fixer/multiuser")
cat > /var/www/html/kill.sh << ENDOFFILE
#!/bin/bash
#By Alireza
i=0
while [ 1i -lt 10 ]; do
cmd=(bbh '$multiin')
echo cmd &
sleep 6
i=(( i + 1 ))
done
ENDOFFILE
wait
sudo sed -i 's/(bbh/$(curl -v -H "A: B"/' /var/www/html/kill.sh
wait
sudo sed -i 's/cmd/$cmd/' /var/www/html/kill.sh
wait
sudo sed -i 's/1i/$i/' /var/www/html/kill.sh
wait
sudo sed -i 's/((/$((/' /var/www/html/kill.sh
wait
chmod +x /var/www/html/kill.sh
wait
if [ "$xport" != "" ]; then
pssl=$((xport+1))
fi
(crontab -l | grep . ; echo -e "* * * * * /var/www/html/kill.sh") | crontab -
(crontab -l ; echo "* * * * * wget -q -O /dev/null '$protcohttp://${defdomain}:$sshttp/fixer/exp' > /dev/null 2>&1") | crontab -
wait
systemctl enable stunnel4 &
wait
systemctl restart stunnel4 &
wait
curl -o /root/xpanel.sh https://raw.githubusercontent.com/vahidazimi/madopanel/master/cli.sh
sudo wget -4 -O /usr/local/bin/xpanel https://raw.githubusercontent.com/vahidazimi/madopanel/master/cli.sh
chmod +x /usr/local/bin/xpanel 
chown www-data:www-data /var/www/html/example/index.php
sed -i "s/PORT_PANEL=.*/PORT_PANEL=$sshttp/g" /var/www/html/app/.env
DEFAULT_APP_LOCALE=en
DEFAULT_APP_MODE=light
DEFAULT_PANEL_DIRECT=cp
DEFAULT_CRON_TRAFFIC=active
DEFAULT_DAY=active
DEFAULT_PORT_DROPBEAR=2083
DEFAULT_TRAFFIC_BASE=12

if [ -f /var/www/html/.env_copy ]; then
  while IFS= read -r line; do
    key=$(echo "$line" | awk -F'=' '{print $1}')
    value=$(echo "$line" | awk -F'=' '{print $2}')

    if [ "$key" = "APP_LOCALE" ]; then
      APP_LOCALE="$value"
    elif [ "$key" = "APP_MODE" ]; then
      APP_MODE="$value"
    elif [ "$key" = "PANEL_DIRECT" ]; then
      PANEL_DIRECT="$value"
    elif [ "$key" = "CRON_TRAFFIC" ]; then
      CRON_TRAFFIC="$value"
    elif [ "$key" = "DAY" ]; then
      DAY="$value"
    elif [ "$key" = "PORT_DROPBEAR" ]; then
      PORT_DROPBEAR="$value"
    elif [ "$key" = "TRAFFIC_BASE" ]; then
      TRAFFIC_BASE="$value"
    fi
  done < /var/www/html/.env_copy
fi

APP_LOCALE="${APP_LOCALE:-$DEFAULT_APP_LOCALE}"
APP_MODE="${APP_MODE:-$DEFAULT_APP_MODE}"
PANEL_DIRECT="${PANEL_DIRECT:-$DEFAULT_PANEL_DIRECT}"
CRON_TRAFFIC="${CRON_TRAFFIC:-$DEFAULT_CRON_TRAFFIC}"
DAY="${DAY:-$DEFAULT_DAY}"
PORT_DROPBEAR="${PORT_DROPBEAR:-$DEFAULT_PORT_DROPBEAR}"
TRAFFIC_BASE="${TRAFFIC_BASE:-$DEFAULT_TRAFFIC_BASE}"

sed -i "s/APP_LOCALE=.*/APP_LOCALE=$APP_LOCALE/g" /var/www/html/app/.env
sed -i "s/APP_MODE=.*/APP_MODE=$APP_MODE/g" /var/www/html/app/.env
sed -i "s/PANEL_DIRECT=.*/PANEL_DIRECT=$PANEL_DIRECT/g" /var/www/html/app/.env
sed -i "s/CRON_TRAFFIC=.*/CRON_TRAFFIC=$CRON_TRAFFIC/g" /var/www/html/app/.env
sed -i "s/DAY=.*/DAY=$DAY/g" /var/www/html/app/.env
sed -i "s/PORT_DROPBEAR=.*/PORT_DROPBEAR=$PORT_DROPBEAR/g" /var/www/html/app/.env
sed -i "s/TRAFFIC_BASE=.*/TRAFFIC_BASE=$TRAFFIC_BASE/g" /var/www/html/app/.env

clear

echo -e "************ MadoPanel ************ \n"
echo -e "XPanel Link : $protcohttp://${defdomain}:$sshttp/login"
echo -e "Username : ${adminusername}"
echo -e "Password : ${adminpassword}"
echo -e "-------- Connection Details ----------- \n"
echo -e "IP : $ipv4 "
echo -e "SSH port : ${port} "
echo -e "SSH + TLS port : ${sshtls_port} \n"
echo -e "************ Check Install Packag and Moudels ************ \n"
check_install() {
    if dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"; then
         echo -e "$1 \e[34m is installed \e[0m"
    else
        if which $1 &>/dev/null; then
         echo -e "$1 \e[34m is installed \e[0m"
    else
        echo -e "$1 \e[31m is not installed \e[0m"
    fi
    fi
}

# Check and display status for each package
check_install software-properties-common
check_install stunnel4
check_install cmake
check_install screenfetch
check_install openssl
check_install apache2
check_install zip
check_install unzip
check_install net-tools
check_install curl
check_install mariadb-server
check_install php
check_install npm
check_install coreutils
check_install php8.1
check_install php8.1-mysql
check_install php8.1-xml
check_install php8.1-curl
check_install cron
check_install nethogs
