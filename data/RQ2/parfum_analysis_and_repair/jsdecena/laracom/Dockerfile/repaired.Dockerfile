FROM jsdecena/php74-fpm

ENV NODE_VERSION=12.6.0
RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install mysqli pdo_mysql gd

COPY project ./

COPY project/.env.example ./.env

RUN curl -f -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm

RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer