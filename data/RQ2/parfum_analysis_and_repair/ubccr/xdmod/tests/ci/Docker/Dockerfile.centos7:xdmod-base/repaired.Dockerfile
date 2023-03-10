FROM centos:7.9.2009
ENV BRANCH=xdmod10.0
LABEL description="Base image containing XDMoD required software."

COPY assets/google-chrome.repo /etc/yum.repos.d

# Dependencies needed by XDMoD
RUN yum makecache && \
    yum -y install epel-release centos-release-scl-rh && \
    yum -y install \
    expect \
    gcc-c++ \
    gnu-free-sans-fonts \
    google-chrome-stable \
    mariadb-server \
    npm \
    openssl \
    postfix \
    rh-nodejs6 \
    rpm-build \
    rsync \
    sudo \
    vim \
    wget && \
    yum -y install https://repo.ius.io/ius-release-el7.rpm && \
    yum -y install git224 && \
    yum -y remove ius-release && \
    curl -f -s https://raw.githubusercontent.com/ubccr/xdmod/$BRANCH/open_xdmod/modules/xdmod/xdmod.spec.in | grep '^Requires' | awk '{$1=""; print $0}' | tr '\n' ' ' | sed -E 's/[ \t]+/\n/g' | sort -u | grep '^[[:alpha:]]' | tr '\n' ' ' | xargs -r yum -y install && \
    curl -f -s https://raw.githubusercontent.com/ubccr/xdmod-supremm/$BRANCH/xdmod-supremm.spec.in | grep '^Requires' | awk '{$1=""; print $0}' | tr '\n' ' ' | sed -E 's/[ \t]+/\n/g' | sort -u | grep '^[[:alpha:]]' | grep -v xdmod | tr '\n' ' ' | xargs -r yum -y install && \
    curl -f -s https://raw.githubusercontent.com/ubccr/xdmod-federated/$BRANCH/xdmod-federated.spec.in | grep '^Requires' | awk '{$1=""; print $0}' | tr '\n' ' ' | sed -E 's/[ \t]+/\n/g' | sort -u | grep '^[[:alpha:]]' | grep -v xdmod | tr '\n' ' ' | xargs -r yum -y install && \
    yum clean all && \
    rm -rf /var/cache/yum

# Set PHP timezone before installing XDMoD as the setup scripts need it. Be careful
# changing the timezone as it may break integration test results if they were written
# for a different zone.
RUN sed -i 's/.*date.timezone[[:space:]]*=.*/date.timezone = UTC/' /etc/php.ini && \
    sed -i 's/.*memory_limit[[:space:]]*=.*/memory_limit = -1/' /etc/php.ini && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Setup Postfix
RUN sed -ie 's/inet_interfaces = localhost/#inet_interfaces = localhost/' /etc/postfix/main.cf  && \
    sed -ie 's/smtp      inet  n       -       n       -       -       smtpd/#smtp      inet  n       -       n       -       -       smtpd/' /etc/postfix/master.cf && \
    sed -ie 's/smtp      unix  -       -       n       -       -       smtp/smtp      unix  -       -       n       -       -       local/' /etc/postfix/master.cf && \
    sed -ie 's/relay     unix  -       -       n       -       -       smtp/relay     unix  -       -       n       -       -       local/' /etc/postfix/master.cf && \
    echo '/.*/ root' >> /etc/postfix/virtual && \
    postmap /etc/postfix/virtual && \
    echo 'virtual_alias_maps = regexp:/etc/postfix/virtual' >> /etc/postfix/main.cf && \
    newaliases

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)" && \
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")" && \
    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then echo 'ERROR: Invalid composer signature'; exit 1; fi && \
    php composer-setup.php --install-dir=/bin --filename=composer --1 && \
    php -r "unlink('composer-setup.php');"
