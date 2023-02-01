FROM linuxmintd/mint20.1-amd64:latest
SHELL ["/bin/bash", "-c"]

USER root

# https://rtfm.co.ua/en/docker-configure-tzdata-and-timezone-during-build/
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /usr/tempdir/

# Update deps
RUN apt-get update -y

# Install os deps
RUN apt-get install --no-install-recommends -y \
    curl && rm -rf /var/lib/apt/lists/*;

# Install docker
RUN apt install --no-install-recommends -y apt-transport-https ca-certificates curl software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
RUN apt-get update && apt-get install --no-install-recommends docker-ce -y && rm -rf /var/lib/apt/lists/*;
RUN newgrp docker
# Install deps for magento-scripts
RUN apt-get install --no-install-recommends -y \
    libcurl4-openssl-dev \
    libonig-dev \
    libjpeg-dev \
    libjpeg8-dev \
    libjpeg-turbo8-dev \
    libpng-dev \
    libicu-dev \
    libfreetype6-dev \
    libzip-dev \
    libssl-dev \
    build-essential \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libonig-dev \
    php-cli \
    php-bz2 \
    pkg-config \
    autoconf && rm -rf /var/lib/apt/lists/*;

# Install node
RUN curl -f -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n && bash n 14.15.1

# Install PHPBrew
RUN curl -f -L -O https://github.com/phpbrew/phpbrew/releases/latest/download/phpbrew.phar && chmod +x phpbrew.phar
RUN mv phpbrew.phar /usr/local/bin/phpbrew
RUN phpbrew init
RUN phpbrew lookup-prefix ubuntu
RUN source $HOME/.phpbrew/bashrc

WORKDIR /usr/src/app/

ADD ./build-packages/ /usr/src/app/build-packages/
ADD ./.yarn /usr/src/app/.yarn/
ADD ./package.json /usr/src/app/
ADD ./lerna.json /usr/src/app/
ADD ./yarn.lock /usr/src/app/
ADD ./.yarnrc /usr/src/app/

ARG COMPOSER_AUTH
ENV COMPOSER_AUTH=${COMPOSER_AUTH}

RUN npm i yarn -g && npm cache clean --force;
# Setup lerna workspace
RUN yarn && yarn cache clean;

# Create sample cma project
RUN ./build-packages/create-magento-app/index.js runtime-packages/cma

WORKDIR /usr/src/app/runtime-packages/cma

# Start project
CMD yarn start --no-open --test-run