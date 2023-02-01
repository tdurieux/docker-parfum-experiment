FROM matthewpatell/universal-docker-server-php-fpm:4.0

# Utils
RUN apt-get update -y --fix-missing \
    && apt-get install --no-install-recommends -y \
            mc htop bash-completion \
            nano vim \
            cron git rsyslog \
            curl wget zip unzip \
    # Fix terminal
    && echo "export TERM=xterm mc" >> ~/.bashrc \

    # Install ssl cerbot
    && apt-get install --no-install-recommends -y software-properties-common \
    && add-apt-repository ppa:certbot/certbot \
    && apt-get update \
    && apt-get install --no-install-recommends -y python-certbot-apache \
    && apt-get remove -y software-properties-common \

    # install sshd
    && apt-get install --no-install-recommends -y openssh-server openssh-client passwd \
    && mkdir -p /var/run/sshd \
    #RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
    && sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    # Put your own public key at id_rsa.pub for key-based login.
    && mkdir -p /root/.ssh && chmod 700 /root/.ssh \
    && touch /root/.ssh/authorized_keys \

    # Install composer
    && curl -f -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \

    # MySQL client
    && apt-get install --no-install-recommends -y mysql-client-5.7 \

    # Install supervisord
    && apt-get install --no-install-recommends -y supervisor \
    && mkdir -p /var/log/supervisord && rm -rf /var/lib/apt/lists/*;

CMD service php${PHP_VERSION}-fpm start && supervisord -n
