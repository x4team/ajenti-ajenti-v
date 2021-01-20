FROM niiknow/docker-hostingbase:1.6.1

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive \
    GOLANG_VERSION=1.8.3 \
    DOTNET_DOWNLOAD_URL=https://download.microsoft.com/download/D/7/A/D7A9E4E9-5D25-4F0C-B071-210CB8267943/dotnet-ubuntu.16.04-x64.1.1.2.tar.gz  \
    IMAGE_FILTER_URL=https://raw.githubusercontent.com/niiknow/docker-nginx-image-proxy/master/build/src/ngx_http_image_filter_module.c

# start
RUN \
    cd /tmp \

# add our user and group first to make sure their IDs get assigned consistently
&& echo "nginx mysql bind clamav ssl-cert dovecot dovenull Debian-exim postgres debian-spamd epmd couchdb memcache mongodb redis" | xargs -n1 groupadd -K GID_MIN=100 -K GID_MAX=999 ${g} \
&& echo "nginx nginx mysql mysql bind bind clamav clamav dovecot dovecot dovenull dovenull Debian-exim Debian-exim postgres postgres debian-spamd debian-spamd epmd epmd couchdb couchdb memcache memcache mongodb mongodb redis redis" | xargs -n2 useradd -d /nonexistent -s /bin/false -K UID_MIN=100 -K UID_MAX=999 -g ${g} \
&& usermod -d /var/lib/mysql mysql \
&& usermod -d /var/cache/bind bind \
&& usermod -d /var/lib/clamav -a -G Debian-exim clamav && usermod -a -G mail clamav \
&& usermod -d /usr/lib/dovecot -a -G mail dovecot \
&& usermod -d /var/spool/exim4 -a -G mail Debian-exim \
&& usermod -d /var/lib/postgresql -s /bin/bash -a -G ssl-cert postgres \
&& usermod -d /var/lib/spamassassin -s /bin/sh -a -G mail debian-spamd \
&& usermod -d /var/run/epmd epmd \
&& usermod -d /var/lib/couchdb -s /bin/bash couchdb \
&& usermod -d /var/lib/redis redis

RUN apt-get -o Acquire::GzipIndexes=false update \

# add nginx repo
&& curl -s https://nginx.org/keys/nginx_signing.key | apt-key add - \
&& cp /etc/apt/sources.list /etc/apt/sources.list.bak \
&& echo "deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx" | tee -a /etc/apt/sources.list \
&& echo "deb-src http://nginx.org/packages/mainline/ubuntu/ xenial nginx" | tee -a /etc/apt/sources.list \


&& wget http://repo.ajenti.org/debian/key -O- | apt-key add - \
&& echo "deb http://repo.ajenti.org/debian main main ubuntu" > /etc/apt/sources.list.d/ajenti.list \

&& apt-get update && apt-get upgrade -y \

&& apt-get install -y mariadb-server mariadb-client redis-server openvpn fail2ban \
&& dpkg --configure -a

# update
RUN apt-get update && apt-get -y --no-install-recommends upgrade \
&& apt-get install -y --no-install-recommends libpcre3-dev libssl-dev dpkg-dev libgd-dev


RUN apt-get install -yq ajenti php-all-dev pkg-php-tools

#Install ajenti-v
RUN apt-get install -yf ajenti-v ajenti-v-nginx ajenti-v-mysql

RUN apt-get install -yf ajenti-v-php7.4-fpm ajenti-v-mail ajenti-v-nodejs ajenti-v-python-gunicorn ajenti-v-ruby-unicorn
RUN service ajenti restart
        
# install other things
RUN apt-get install -yf memcached php-memcache php-memcached redis-server openvpn \
easy-rsa bind9 bind9utils bind9-doc

#Install Letsencrypt (Dehydrated) 
RUN add-apt-repository ppa:gslin/dehydrated -y && apt-get update && apt-get install -y dehydrated 

# setting up dotnet, awscli, golang
# dotnet
RUN curl -SL $DOTNET_DOWNLOAD_URL -o /tmp/dotnet.tar.gz \
&& mkdir -p /usr/share/dotnet \
&& tar -zxf /tmp/dotnet.tar.gz -C /usr/share/dotnet \
&& ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \

# awscli
&& curl -O https://bootstrap.pypa.io/get-pip.py \
&& python get-pip.py \
&& pip install awscli \
&& pip uninstall urllib3 -y \
&& pip install urllib3==1.23 \
&& service ajenti restart \
# getting golang
&& cd /tmp \
&& curl -SL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz -o /tmp/golang.tar.gz \
&& tar -zxf golang.tar.gz \
&& mv go /usr/local \
&& echo "\nGOROOT=/usr/local/go\nexport GOROOT\n" >> /root/.profile

RUN apt-get install -yq ajenti-v-php5.6-fpm && \
apt-get install -yq php5.6-fpm php5.6-mbstring php5.6-cgi php5.6-cli php5.6-dev php5.6-geoip php5.6-common php5.6-xmlrpc && \
apt-get install -yq php5.6-dev php5.6-curl php5.6-enchant php5.6-imap php5.6-xsl php5.6-mysql php5.6-mysqlnd php5.6-pspell php5.6-gd && \
apt-get install -yq php5.6-tidy php5.6-opcache php5.6-json php5.6-bz2 php5.6-pgsql php-mcrypt php-readline php5.6-sybase && \
apt-get install -yq php5.6-intl php5.6-sqlite3 php5.6-ldap php5.6-xml php5.6-redis php5.6-imagick php5.6-zip

RUN apt-get install -yq ajenti-v-php7.0-fpm && \
apt-get install -yq php7.0-fpm php7.0-mbstring php7.0-cgi php7.0-cli php7.0-dev php7.0-geoip php7.0-common php7.0-xmlrpc && \
apt-get install -yq php7.0-dev php7.0-curl php7.0-enchant php7.0-imap php7.0-xsl php7.0-mysql php7.0-mysqlnd php7.0-pspell php7.0-gd && \
apt-get install -yq php7.0-tidy php7.0-opcache php7.0-json php7.0-bz2 php7.0-pgsql php-mcrypt php-readline php7.0-sybase && \
apt-get install -yq php7.0-intl php7.0-sqlite3 php7.0-ldap php7.0-xml php7.0-redis php7.0-imagick php7.0-zip

RUN apt-get install -yq php7.1-fpm php7.1-mbstring php7.1-cgi php7.1-cli php7.1-dev php7.1-geoip php7.1-common php7.1-xmlrpc && \
apt-get install -yq php7.1-dev php7.1-curl php7.1-enchant php7.1-imap php7.1-xsl php7.1-mysql php7.1-mysqlnd php7.1-pspell php7.1-gd && \
apt-get install -yq php7.1-tidy php7.1-opcache php7.1-json php7.1-bz2 php7.1-pgsql php-mcrypt php-readline php7.1-sybase && \
apt-get install -yq php7.1-intl php7.1-sqlite3 php7.1-ldap php7.1-xml php7.1-redis php7.1-imagick php7.1-zip

RUN apt-get install -yq ajenti-v-php7.1-fpm && \
apt-get install -yq php7.1-fpm php7.1-mbstring php7.1-cgi php7.1-cli php7.1-dev php7.1-geoip php7.1-common php7.1-xmlrpc && \
apt-get install -yq php7.1-dev php7.1-curl php7.1-enchant php7.1-imap php7.1-xsl php7.1-mysql php7.1-mysqlnd php7.1-pspell php7.1-gd && \
apt-get install -yq php7.1-tidy php7.1-opcache php7.1-json php7.1-bz2 php7.1-pgsql php-mcrypt php-readline php7.1-sybase && \
apt-get install -yq php7.1-intl php7.1-sqlite3 php7.1-ldap php7.1-xml php7.1-redis php7.1-imagick php7.1-zip

RUN apt-get install -yq ajenti-v-php7.2-fpm && \
apt-get install -yq php7.2-fpm php7.2-mbstring php7.2-cgi php7.2-cli php7.2-dev php7.2-geoip php7.2-common php7.2-xmlrpc && \
apt-get install -yq php7.2-dev php7.2-curl php7.2-enchant php7.2-imap php7.2-xsl php7.2-mysql php7.2-mysqlnd php7.2-pspell php7.2-gd && \
apt-get install -yq php7.2-tidy php7.2-opcache php7.2-json php7.2-bz2 php7.2-pgsql php-mcrypt php-readline php7.2-sybase && \
apt-get install -yq php7.2-intl php7.2-sqlite3 php7.2-ldap php7.2-xml php7.2-redis php7.2-imagick php7.2-zip

RUN apt-get install -yq ajenti-v-php7.3-fpm && \
apt-get install -yq php7.3-fpm php7.3-mbstring php7.3-cgi php7.3-cli php7.3-dev php7.3-geoip php7.3-common php7.3-xmlrpc && \
apt-get install -yq php7.3-dev php7.3-curl php7.3-enchant php7.3-imap php7.3-xsl php7.3-mysql php7.3-mysqlnd php7.3-pspell php7.3-gd && \
apt-get install -yq php7.3-tidy php7.3-opcache php7.3-json php7.3-bz2 php7.3-pgsql php-mcrypt php-readline php7.3-sybase && \
apt-get install -yq php7.3-intl php7.3-sqlite3 php7.3-ldap php7.3-xml php7.3-redis php7.3-imagick php7.3-zip
    
RUN apt-get install -yq php7.4-fpm php7.4-mbstring php7.4-cgi php7.4-cli php7.4-dev php7.4-geoip php7.4-common php7.4-xmlrpc
RUN apt-get install -yq php7.4-dev php7.4-curl php7.4-enchant php7.4-imap php7.4-xsl php7.4-mysql php7.4-mysqlnd php7.4-pspell php7.4-gd
RUN apt-get install -yq php7.4-tidy php7.4-opcache php7.4-json php7.4-bz2 php7.4-pgsql php-mcrypt php-readline php7.4-sybase
RUN apt-get install -yq php7.4-intl php7.4-sqlite3 php7.4-ldap php7.4-xml php7.4-redis php7.4-imagick php7.4-zip

# add files
COPY ajenti-plugins/. /var/lib/ajenti/plugins/
# add files
RUN apt-get install openssh-server -yf

# update ajenti, install other things
RUN \
    cd /tmp \
&& mkdir -p /www
RUN  chown -R www-data:www-data /www \

# no idea why 1000:1000 but that's the permission ajenti installed with
&& chown -R 1000:1000 /var/lib/ajenti

# change to more useful folder structure
RUN sed -i -e "s/\/srv\/new\-website/\/www\/new\-website/g" /var/lib/ajenti/plugins/vh/api.py

RUN sed -i -e "s/'php-fcgi'/'php7.4-fcgi'/g" /var/lib/ajenti/plugins/vh/api.py

# increase memcache max size from 64m to 2g
RUN sed -i -e "s/^\-m 64/\-m 2048/g" /etc/memcached.conf

RUN echo "extension=v8js.so" > /etc/php/7.4/mods-available/v8js.ini \
&& ln -sf /etc/php/7.4/mods-available/v8js.ini /etc/php/7.4/fpm/conf.d/20-v8js.ini \
&& ln -sf /etc/php/7.4/mods-available/v8js.ini /etc/php/7.4/cli/conf.d/20-v8js.ini \
&& ln -sf /etc/php/7.4/mods-available/v8js.ini /etc/php/7.4/cgi/conf.d/20-v8js.ini

RUN echo "extension=pcs.so" > /etc/php/7.4/mods-available/pcs.ini \
&& ln -sf /etc/php/7.4/mods-available/pcs.ini /etc/php/7.4/fpm/conf.d/15-pcs.ini \
&& ln -sf /etc/php/7.4/mods-available/pcs.ini /etc/php/7.4/cli/conf.d/15-pcs.ini \
&& ln -sf /etc/php/7.4/mods-available/pcs.ini /etc/php/7.4/cgi/conf.d/15-pcs.ini

RUN echo "extension=v8js.so" > /etc/php/7.1/mods-available/v8js.ini \
&& ln -sf /etc/php/7.1/mods-available/v8js.ini /etc/php/7.1/fpm/conf.d/20-v8js.ini \
&& ln -sf /etc/php/7.1/mods-available/v8js.ini /etc/php/7.1/cli/conf.d/20-v8js.ini \
&& ln -sf /etc/php/7.1/mods-available/v8js.ini /etc/php/7.1/cgi/conf.d/20-v8js.ini

RUN echo "extension=pcs.so" > /etc/php/7.1/mods-available/pcs.ini \
&& ln -sf /etc/php/7.1/mods-available/pcs.ini /etc/php/7.1/fpm/conf.d/15-pcs.ini \
&& ln -sf /etc/php/7.1/mods-available/pcs.ini /etc/php/7.1/cli/conf.d/15-pcs.ini \
&& ln -sf /etc/php/7.1/mods-available/pcs.ini /etc/php/7.1/cgi/conf.d/15-pcs.ini

RUN echo "extension=v8js.so" > /etc/php/7.1/mods-available/v8js.ini \
&& ln -sf /etc/php/7.3/mods-available/v8js.ini /etc/php/7.3/fpm/conf.d/20-v8js.ini \
&& ln -sf /etc/php/7.3/mods-available/v8js.ini /etc/php/7.3/cli/conf.d/20-v8js.ini \
&& ln -sf /etc/php/7.3/mods-available/v8js.ini /etc/php/7.3/cgi/conf.d/20-v8js.ini

RUN echo "extension=pcs.so" > /etc/php/7.1/mods-available/pcs.ini \
&& ln -sf /etc/php/7.3/mods-available/pcs.ini /etc/php/7.3/fpm/conf.d/15-pcs.ini \
&& ln -sf /etc/php/7.3/mods-available/pcs.ini /etc/php/7.3/cli/conf.d/15-pcs.ini \
&& ln -sf /etc/php/7.3/mods-available/pcs.ini /etc/php/7.3/cgi/conf.d/15-pcs.ini


# increase memcache max size from 64m to 256m
RUN sed -i -e "s/^\-m 64/\-m 256/g" /etc/memcached.conf

RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 5000M/" /etc/php/7.1/fpm/php.ini \
&& sed -i "s/post_max_size = 8M/post_max_size = 5000M/" /etc/php/7.1/fpm/php.ini \
&& sed -i "s/max_input_time = 60/max_input_time = 360000/" /etc/php/7.1/fpm/php.ini \
&& sed -i "s/max_execution_time = 30/max_execution_time = 360000/" /etc/php/7.1/fpm/php.ini \
&& sed -i -e "s/;sendmail_path =/sendmail_path = \/usr\/sbin\/exim \-t/g" /etc/php/7.1/fpm/php.ini

RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 5000M/" /etc/php/7.3/fpm/php.ini \
&& sed -i "s/post_max_size = 8M/post_max_size = 5000M/" /etc/php/7.3/fpm/php.ini \
&& sed -i "s/max_input_time = 60/max_input_time = 360000/" /etc/php/7.3/fpm/php.ini \
&& sed -i "s/max_execution_time = 30/max_execution_time = 360000/" /etc/php/7.3/fpm/php.ini \
&& sed -i -e "s/;sendmail_path =/sendmail_path = \/usr\/sbin\/exim \-t/g" /etc/php/7.3/fpm/php.ini

RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 5000M/" /etc/php/5.6/fpm/php.ini \
&& sed -i "s/post_max_size = 8M/post_max_size = 5000M/" /etc/php/5.6/fpm/php.ini \
&& sed -i "s/max_input_time = 60/max_input_time = 360000/" /etc/php/5.6/fpm/php.ini \
&& sed -i "s/max_execution_time = 30/max_execution_time = 360000/" /etc/php/5.6/fpm/php.ini \
&& sed -i -e "s/;sendmail_path =/sendmail_path = \/usr\/sbin\/exim \-t/g" /etc/php/5.6/fpm/php.ini

#RUN sed -i -e "s/PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config \
#&& sed -i -e "s/^#PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config \
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 5000M/" /etc/php/7.4/fpm/php.ini \
&& sed -i "s/post_max_size = 8M/post_max_size = 5000M/" /etc/php/7.4/fpm/php.ini \
&& sed -i "s/max_input_time = 60/max_input_time = 360000/" /etc/php/7.4/fpm/php.ini \
&& sed -i "s/max_execution_time = 30/max_execution_time = 360000/" /etc/php/7.4/fpm/php.ini \
&& sed -i -e "s/;sendmail_path =/sendmail_path = \/usr\/sbin\/exim \-t/g" /etc/php/7.4/fpm/php.ini \

# increase open file limit for nginx and apache
&& echo "\n\n* soft nofile 800000\n* hard nofile 800000\n\n" >> /etc/security/limits.conf

RUN service mysql stop \
&& service redis-server stop \
&& service fail2ban stop
COPY sshd_config /etc/ssh/sshd_config
RUN service ssh start
# setup redis like memcache
RUN sed -i -e "s/127\.0\.0\.1/\*/g" /etc/redis/redis.conf \
&& sed -i -e 's:^save:# save:g' \
      -e 's:^bind:# bind:g' \
      -e 's:^logfile:# logfile:' \
      -e 's:daemonize yes:daemonize no:' \
      -e 's:# maxmemory \(.*\)$:maxmemory 512mb:' \
      -e 's:# maxmemory-policy \(.*\)$:maxmemory-policy allkeys-lru:' \
      /etc/redis/redis.conf

COPY ./services.conf /etc/supervisor/conf.d/services.conf
RUN echo user=root >>  /etc/supervisor/supervisord.conf
   
# pagespeed stuff
RUN mkdir -p /var/ngx_pagespeed_cache \
&& chmod 755 /var/ngx_pagespeed_cache \
&& chown www-data:www-data /var/ngx_pagespeed_cache \
# finish cleaning up
&& dpkg --configure -a \
&& rm -rf /backup/.etc \
&& rm -rf /tmp/* \
&& apt-get -yf autoremove \
&& apt-get clean 
RUN echo "exit 0" > /usr/sbin/policy-rc.d
RUN pip install pip==9.0.3
COPY root/. /root/
# https://github.com/Eugeny/ajenti-v/pull/185
RUN sed -i -e "s/'reload'/'update'/g" /var/lib/ajenti/plugins/vh/processes.py
CMD ["/usr/bin/supervisord", "-n"]
RUN mkdir /var/log/php-fpm/
RUN mkdir /etc/dehydrated
VOLUME ["/backup", "/home", "/www", "/etc/dehydrated", "/var/lib/mysql", "/etc/ajenti", "/etc/php"]
EXPOSE 22 25 53 54 80 110 143 443 465 587 993 995 1194 3000 3306 5432 5984 6379 8000 8001 10022 11211 27017
