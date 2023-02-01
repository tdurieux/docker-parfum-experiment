FROM centos:7

ARG user_var="root"

#SHELL ["/bin/bash", "-c"]


RUN yum -y update
RUN yum -y update tzdata
RUN yum -y install bash-completion bash-completion-extras && rm -rf /var/cache/yum



########## needed for PHP
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rm -rf /var/cache/yum
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && rm -rf /var/cache/yum

RUN yum -y install yum-utils && rm -rf /var/cache/yum

RUN yum-config-manager --enable remi-php56



# Install php (cli/fpm)
RUN yum -y install \
        php \
        php-cli \
        php-fpm \
        php-json \
        php-intl \
        php-curl \
        php-dom \
        php-mbstring \
        php-bcmath \
        python3 \
        python3-pandas \
        python3-xlsxwriter \
        python3-netaddr \
        python3-requests \
    && yum clean all && rm -rf /var/cache/yum


### PAN-OS-PHP
WORKDIR /tools/pan-os-php

COPY appid-toolbox ./appid-toolbox
COPY lib ./lib
COPY phpseclib ./phpseclib
COPY git-php ./git-php
COPY utils ./utils
COPY tests ./tests


# PHP library of pan-os-php
RUN echo 'include_path = "/usr/share/php:/tools/pan-os-php"' >> /etc/php.ini
RUN chmod -R 777 /tools/pan-os-php


# UTIL alias for pan-os-php
RUN cat /tools/pan-os-php/utils/alias.sh >> /$user_var/.bashrc
RUN cat /tools/pan-os-php/utils/bash_autocompletion/enable_bash.txt >> /$user_var/.bashrc

COPY utils/bash_autocompletion/pan-os-php.sh /usr/share/bash-completion/completions/pan-os-php

RUN git config --global user.email=test@test.com user.name=test

#for BASH 5.0
RUN yum -y install curl && rm -rf /var/cache/yum
RUN yum -y groupinstall "Development Tools"
RUN curl -f -O https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz
RUN tar xvf bash-5.0.tar.gz && rm bash-5.0.tar.gz
RUN cd bash-5.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

#echo '/usr/local/bin/bash' >> /etc/shells
#chsh -s /usr/local/bin/bash

RUN yes | cp /usr/local/bin/bash /bin/bash

# Entrypoint script
WORKDIR /scripts
COPY docker/entrypoint.sh .

# Working dir for the app
VOLUME /share
WORKDIR /share

ENTRYPOINT [ "/bin/bash", "/scripts/entrypoint.sh" ]
