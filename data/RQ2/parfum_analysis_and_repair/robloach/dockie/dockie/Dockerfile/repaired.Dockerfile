# Dockie Development Environment

FROM ubuntu:15.10
MAINTAINER Rob Loach <robloach@gmail.com>


# Update

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get upgrade -y


# Supervisor

RUN apt-get install --no-install-recommends -y supervisor && \
  mkdir -p /var/log/supervisor && \
  supervisord --version && rm -rf /var/lib/apt/lists/*;
ADD configs/supervisor/supervisor.conf /etc/supervisor/conf.d/supervisor.conf


# Base Dependencies

RUN apt-get install --no-install-recommends -y software-properties-common wget mysql-client unzip postfix \
  git mercurial subversion iputils-ping && \
  git --version && \
  hg --version && \
  svn --version && rm -rf /var/lib/apt/lists/*;


# Zsh

RUN apt-get install --no-install-recommends -y zsh && \
  git clone git://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh && \
  chsh --shell $(which zsh) && \
  zsh --version && rm -rf /var/lib/apt/lists/*;
ADD configs/oh-my-zsh/zshrc /root/.zshrc


# PHP

RUN apt-get install --no-install-recommends -y php5-apcu php-pear php5-cgi php5-json php5-cli php5-curl curl \
  php5-mcrypt php5-xdebug mcrypt libmcrypt-dev php5-mysql php5-gd php5-sqlite \
  sqlite imagemagick php5-imagick && \
  php5enmod mcrypt pdo pdo_sqlite sqlite3 && \
  php --version && rm -rf /var/lib/apt/lists/*;
ADD configs/php/php-cli.ini /etc/php5/cli/conf.d/dockie-dockie.ini


# Composer

ENV COMPOSER_HOME /root/.composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH
RUN curl -f -sS https://getcomposer.org/installer | php -- --filename=composer \
  --install-dir=/usr/bin --version=1.0.0-alpha10
RUN composer --version


# PHPUnit

RUN composer global require phpunit/phpunit:5.* && \
  phpunit --version


# Drush

RUN composer global require drush/drush:8.* && \
  drush --version


# Python

RUN apt-get install --no-install-recommends -y python python3 python-pil pylint && \
python --version && \
python3 --version && rm -rf /var/lib/apt/lists/*;


# Node.js

RUN apt-get install --no-install-recommends -y build-essential && \
  curl -f -sL https://deb.nodesource.com/setup_4.x | sh - && rm -rf /var/lib/apt/lists/*;
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y nodejs && \
  nodejs --version && \
  npm --version && \
  npm install -g coffee-script bower grunt-cli gulp component yo eslint && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;


# Ruby

RUN apt-get install --no-install-recommends -y ruby ruby-dev ri && \
  ruby --version && \
  echo "Gem version:" && gem --version && rm -rf /var/lib/apt/lists/*;
RUN gem install rake bundler sass && \
  bundle --version && rake --version && sass --version && \
  gem install compass && \
  compass --version


# Go

RUN apt-get install --no-install-recommends -y golang && \
  go version && rm -rf /var/lib/apt/lists/*;


# Rust

RUN mkdir -p /tmp/rust && cd /tmp/rust && \
  wget https://static.rust-lang.org/dist/rust-1.3.0-x86_64-unknown-linux-gnu.tar.gz
RUN cd /tmp/rust && tar -zxvf * && cd r* && \
  ./install.sh && rm -rf /tmp/rust
RUN rustc --version
RUN cargo --version


# Version Check

COPY configs/dockie/dockie-version /dockie-version
RUN chmod +x /dockie-version


# Clean up

RUN apt-get clean && apt-get autoremove
RUN /dockie-version


# Start

VOLUME /app
EXPOSE 22
CMD ["supervisord"]
