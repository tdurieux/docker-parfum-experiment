FROM ubuntu:12.04
MAINTAINER Boris Böhne <info@drubb.de>

#
# Step 1: Installation
#

# Set frontend. We'll clean this later on!
ARG DEBIAN_FRONTEND=noninteractive

# Expose web root as volume
VOLUME ["/var/www"]

# Add additional repostories needed later
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu precise main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DF1F24

# Update repositories cache and distribution
RUN apt-get -qq update && apt-get -qqy upgrade

# Install some basic tools needed for deployment
RUN apt-get -yqq --no-install-recommends install apt-utils sudo build-essential debconf-utils locales curl wget unzip patch dkms supervisor && rm -rf /var/lib/apt/lists/*;

# Add the docker user
ENV HOME /home/docker
RUN useradd docker && passwd -d docker && adduser docker sudo
RUN mkdir -p $HOME && chown -R docker:docker $HOME

# Install SSH client
RUN apt-get -yqq --no-install-recommends install openssh-client && rm -rf /var/lib/apt/lists/*;

# Install ssmtp MTA
RUN apt-get -yqq --no-install-recommends install ssmtp && rm -rf /var/lib/apt/lists/*;

# Install Apache web server
RUN apt-get -yqq --no-install-recommends install apache2-mpm-prefork && rm -rf /var/lib/apt/lists/*;

# Install MySQL server and save initial configuration
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get -yqq --no-install-recommends install mysql-server && rm -rf /var/lib/apt/lists/*;
RUN service mysql start && sleep 5 && service mysql stop && tar cpPzf /mysql.tar.gz /var/lib/mysql

# Install PHP5 with Xdebug, APC and other modules
RUN apt-get -yqq --no-install-recommends install libapache2-mod-php5 php5-mcrypt php5-dev php5-mysql php5-curl php5-gd php5-intl php5-xdebug php-apc && rm -rf /var/lib/apt/lists/*;

# Install PEAR package manager
RUN apt-get -yqq --no-install-recommends install php-pear && pear channel-update pear.php.net && pear upgrade-all && rm -rf /var/lib/apt/lists/*;

# Install PECL package manager
RUN apt-get -yqq --no-install-recommends install libpcre3-dev && rm -rf /var/lib/apt/lists/*;

# Install PECL uploadprogress extension
RUN pecl install uploadprogress

# Update APC to latest version
RUN printf "\n" | pecl update apc

# Install memcached service
RUN apt-get -yqq --no-install-recommends install memcached php5-memcached && rm -rf /var/lib/apt/lists/*;

# Install GIT (latest version)
RUN apt-get -yqq --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# Install composer (latest version)
RUN curl -f -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Install drush (latest stable for php 5.3)
USER docker
RUN sudo composer global require "drush/drush:7.*"
USER root

# Install PhpMyAdmin (latest php 5.3 compatible version)
RUN wget -q -O phpmyadmin.zip https://github.com/phpmyadmin/phpmyadmin/archive/MAINT_4_4_15.zip && unzip -qq phpmyadmin.zip
RUN rm phpmyadmin.zip && mv phpmyadmin-MAINT_4_4_15 /opt/phpmyadmin

# Install zsh / OH-MY-ZSH
RUN apt-get -yqq --no-install-recommends install zsh && git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh && rm -rf /var/lib/apt/lists/*;

# Install PROST drupal deployment script, see https://www.drupal.org/sandbox/axroth/1668300
RUN git clone --branch master http://git.drupal.org/sandbox/axroth/1668300.git /tmp/prost
RUN chmod +x /tmp/prost/install.sh

# Install some useful cli tools
RUN apt-get -yqq --no-install-recommends install mc htop vim nano net-tools mlocate && rm -rf /var/lib/apt/lists/*;

# Cleanup some things
RUN apt-get -yqq autoremove; apt-get -yqq autoclean; apt-get clean

# Expose some ports to the host system (web server, MySQL, Xdebug)
EXPOSE 80 3306 9000

#
# Step 2: Configuration
#

# Localization
RUN dpkg-reconfigure locales && locale-gen de_DE.UTF-8 && /usr/sbin/update-locale LANG=de_DE.UTF-8
ENV LC_ALL de_DE.UTF-8

# Set timezone
RUN echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# Add apache web server configuration file
ADD config/httpd.conf /etc/apache2/httpd.conf

# Configure needed apache modules and disable default site
RUN a2enmod rewrite headers deflate expires && a2dismod cgi autoindex status && a2dissite default

# Add additional php configuration file
ADD config/php.ini /etc/php5/conf.d/php.ini

# Add additional mysql configuration file
ADD config/mysql.cnf /etc/mysql/conf.d/mysql.cnf
RUN chmod 0664 /etc/mysql/conf.d/mysql.cnf

# Add memcached configuration file
ADD config/memcached.conf /etc/memcached.conf

# Add ssmtp configuration file
ADD config/ssmtp.conf /etc/ssmtp/ssmtp.conf

# Add phpmyadmin configuration file
ADD config/config.inc.php /opt/phpmyadmin/config.inc.php
RUN chmod 0664 /opt/phpmyadmin/config.inc.php

# Add git global configuration files
ADD config/.gitconfig $HOME/.gitconfig
ADD config/.gitignore $HOME/.gitignore

# Add drush global configuration file
ADD config/drushrc.php $HOME/.drush/drushrc.php

# Add apc status script
RUN mkdir /opt/apc && gunzip -c /usr/share/doc/php-apc/apc.php.gz > /opt/apc/apc.php

# Add zsh configuration
ADD config/.zshrc $HOME/.zshrc

# Configure PROST drupal deployment script
RUN chown docker:docker $HOME/.zshrc
USER docker
ENV SHELL /bin/zsh
RUN export PATH="$HOME/.composer/vendor/bin:$PATH" && cd /tmp/prost && ./install.sh -noupdate $HOME/.prost
USER root
RUN rm -rf /tmp/prost

# ADD ssh keys needed for connections to external servers
ADD .ssh $HOME/.ssh
RUN echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

# Add startup script
ADD startup.sh $HOME/startup.sh

# Supervisor configuration
ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Entry point for the container
RUN chown -R docker:docker $HOME && chmod +x $HOME/startup.sh
USER docker
ENV SHELL /bin/zsh
WORKDIR /var/www
CMD ["/bin/bash", "-c", "$HOME/startup.sh"]
