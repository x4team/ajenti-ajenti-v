wget -O- https://raw.github.com/ajenti/ajenti/1.x/scripts/install-ubuntu.sh | sudo sh
service ajenti restart

apt-get install -yq ajenti-v ajenti-v-nginx ajenti-v-mysql ajenti-v-php-fpm ajenti-v-php5.6-fpm ajenti-v-mail ajenti-v-nodejs ajenti-v-python-gunicorn ajenti-v-ruby-unicorn php5.6-mysql php-all-dev pkg-php-tools

curl -SL https://download.microsoft.com/download/D/7/A/ -o /tmp/dotnet.tar.gz
mkdir -p /usr/share/dotnet
tar -zxf /tmp/dotnet.tar.gz -C /usr/share/dotnet
ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

apt-get install -yf nodejs memcached php-memcached easy-rsa bind9 bind9utils bind9-doc       
ln -sf "$(which nodejs)" /usr/bin/node
curl -O https://bootstrap.pypa.io/get-pip.py \
	python get-pip.py \
    pip install awscli \
ln -sf "$(which nodejs)" /usr/bin/node

cd /tmp
curl -SL https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz -o /tmp/golang.tar.gz
tar -zxf golang.tar.gz
mv go /usr/local
echo "\nGOROOT=/usr/local/go\nexport GOROOT\n" >> /root/.profile
apt-get install -yq php5.6-fpm php5.6-mbstring php5.6-cgi php5.6-cli php5.6-dev php5.6-geoip php5.6-common php5.6-xmlrpc \
        php5.6-dev php5.6-curl php5.6-enchant php5.6-imap php5.6-xsl php5.6-mysql php5.6-mysqlnd php5.6-pspell php5.6-gd \
        php5.6-tidy php5.6-opcache php5.6-json php5.6-bz2 php5.6-mcrypt php5.6-readline php5.6-sybase \
        php5.6-intl php5.6-sqlite3 php5.6-ldap php5.6-xml php5.6-redis php5.6-imagick php5.6-zip -yf
apt-get install -yq php-fpm php-mbstring php-cgi php-cli php-dev php-common php-xmlrpc \
        php-dev php-curl php-enchant php-imap php-xsl php-mysql php-mysqlnd php-pspell php-gd \
        php-tidy php-opcache php-json php-bz2 php-readline php-sybase \
        php-intl php-sqlite3 php-ldap php-xml php-zip -yf
apt-get -yf autoremove
apt-get clean
service ajenti restart
