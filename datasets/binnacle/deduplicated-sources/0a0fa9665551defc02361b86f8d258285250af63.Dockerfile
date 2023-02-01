FROM publicisworldwide/jenkins-slave
MAINTAINER "Heiko Hardt" <heiko.hardt@publicispixelpark.de>

ENV container docker
ENV version_phantomjs 2.1.1
ENV version_selenium 2.53.1
ENV version_firefox 46.0.1
ENV SYSTEMCTL_SKIP_REDIRECT foo


##########################################################################
## publicis standard setup

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
        bzip2 \
        unzip \
        git \
        wget \
        java-1.8.0-openjdk \
    yum clean all

RUN mkdir -pv /jenkins


##########################################################################
## build tools

# Setup Nodejs
RUN yum install -y nodejs npm && \
    npm install -g grunt-cli && \
    npm install -g karma-cli && \
    yum clean all

# Setup compass
RUN yum-config-manager --enable ol7_optional_latest && \
    yum clean all && \
    yum install -y ruby ruby-devel gcc make && \
    gem install json_pure && \
    gem update --system && \
    gem install compass && \
    yum clean all


##########################################################################
## acceptance test tools

# Setup (dev) - tools
RUN yum install -y tree make which curl GraphicsMagick ghostscript gtk3 xorg-x11-server-Xvfb && \
    yum clean all

# Acceptance user
RUN adduser screener

# Firefox
RUN cd /opt && \
    # get and extract binaries
    wget https://ftp.mozilla.org/pub/firefox/releases/${version_firefox}/linux-x86_64/de/firefox-${version_firefox}.tar.bz2 && \
    tar xvjf firefox-${version_firefox}.tar.bz2 && \
    rm -f firefox-${version_firefox}.tar.bz2 && \
    mv firefox firefox.${version_firefox} && \
    # setup symlink
    ln -s /opt/firefox.${version_firefox}/firefox /usr/local/bin/ && \
    # adjust permissions
    chmod +x /usr/local/bin/firefox && \
    chown -R screener:screener /opt/firefox.${version_firefox} && \
    chown -R screener:screener /usr/local/bin/firefox

# Phantomjs
RUN cd /opt && \
    # get and extract binaries
    wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${version_phantomjs}-linux-x86_64.tar.bz2 && \
    tar xvjf phantomjs-${version_phantomjs}-linux-x86_64.tar.bz2 && \
    rm -Rf phantomjs-${version_phantomjs}-linux-x86_64.tar.bz2 && \
    # setup logdir
    mkdir -p /var/log/phantomjs && \
    # setup symlink
    ln -s /opt/phantomjs-${version_phantomjs}-linux-x86_64/bin/phantomjs /usr/local/bin && \
    # adjust permissions
    chmod +x /usr/local/bin/phantomjs && \
    chown -R screener:screener /opt/phantomjs-${version_phantomjs}-linux-x86_64 && \
    chown -R screener:screener /usr/local/bin/phantomjs && \
    chown -R screener:screener /var/log/phantomjs

# Selenium
RUN version_selenium_short=$(echo ${version_selenium} | cut -d\. -f1-2) && \
    # get binaries
    mkdir -p /opt/selenium-server && \
    cd /opt/selenium-server && \
    wget https://selenium-release.storage.googleapis.com/${version_selenium_short}/selenium-server-standalone-${version_selenium}.jar && \
    # setup logdir
    mkdir -p /var/log/selenium-server && \
    # adjust permissions
    chown -R screener:screener /opt/selenium-server && \
    chown -R screener:screener /var/log/selenium-server


##########################################################################
## web environment

# Install apache + mariadb
RUN yum install -y httpd  mariadb-server mariadb && \
    yum clean all

# Prepare behat document root
RUN mkdir -p /var/www/behat && \
    chown apache:apache /var/www/behat && \
    chmod 2777 /var/www/behat

COPY /conf.files/etc/httpd/conf.d/* /etc/httpd/conf.d/

# Setup php
RUN yum install -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    yum install -y yum-utils && \
    yum-config-manager --enable remi-php56 && \
    yum install -y php php-mysql php-gd php-opcache php-mbstring php-xdebug && \
    yum clean all

COPY /conf.files/etc/php.d/* /etc/php.d/

# Setup composer
RUN yum install -y composer && \
    yum clean all

# Prepare environment
RUN mkdir -p /jenkins.workspace/dir-project && \
    mkdir -p /jenkins.workspace/dir-ci && \
    mkdir -p /jenkins.workspace/dir-architecture && \
    mkdir -p /jenkins.workspace/dir-tools && \
    chmod -R 777 /jenkins.workspace


##########################################################################
## init scripts

ENV SERVICES "phantomjs selenium mariadb httpd"

COPY /conf.files/etc/init.d/* /etc/init.d/
RUN for i in ${SERVICES} ; do chmod -v +x /etc/init.d/"$i" ; done
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod -v u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
