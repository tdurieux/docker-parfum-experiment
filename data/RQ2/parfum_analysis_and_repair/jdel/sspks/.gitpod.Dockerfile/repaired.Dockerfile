FROM gitpod/workspace-full

USER root

# Update APT Database
### base ###
RUN sudo apt-get update -q \
    && sudo apt-get install --no-install-recommends -y php-dev && rm -rf /var/lib/apt/lists/*;

# Install XDebug
RUN wget https://xdebug.org/files/xdebug-2.9.1.tgz \
    && tar -xvzf xdebug-2.9.1.tgz \
    && cd xdebug-2.9.1 \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && sudo mkdir -p /usr/lib/php/20190902 \
    && sudo cp modules/xdebug.so /usr/lib/php/20190902 \
    && sudo bash -c "echo -e '\nzend_extension = /usr/lib/php/20190902/xdebug.so\n[XDebug]\nxdebug.remote_enable = 1\nxdebug.remote_autostart = 1\n' >> /etc/php/7.4/cli/php.ini" && rm xdebug-2.9.1.tgz

# Install latest composer v2 release
RUN curl -f -s https://getcomposer.org/installer | php \
    && sudo mv composer.phar /usr/bin/composer \
    && sudo mkdir -p /home/gitpod/.config \
    && sudo chown -R gitpod:gitpod /home/gitpod/.config

USER gitpod

# Install Changelogger
RUN COMPOSER_ALLOW_SUPERUSER=1 composer global require churchtools/changelogger

# Add composer bin folder to $PATH
#ENV PATH="$PATH:/home/gitpod/.config/composer/vendor/bin"

# Add Workspace/Project composer bin folder to $PATH
ENV PATH="$PATH:$HOME/.config/composer/vendor/bin:$GITPOD_REPO_ROOT/vendor/bin"