# Start with Ubuntu Trusty
FROM  phusion/baseimage:0.10.0 AS BuildImage

# Use baseimage-docker's init system.
CMD   ["/sbin/my_init"]

RUN	apt-get update && apt-get install -y \
    wget \
    curl \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install -y \
    nodejs \
    git-core \
    && npm install yarn@1.9.4 -g \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy source files to container
COPY	. /var/www/node

# Install all my packages, build and cleanup
RUN	cd /var/www/node \
    && yarn install --force \
    && yarn build:tsoa \
    && yarn cache clean \
    && npm prune --production \
    && rm -rf node_modules/aws-sdk/dist/* \
    && rm -rf node_modules/aws-sdk/clients/* \
    && rm -rf node_modules/aws-sdk/apis/* \
    && rm -rf node_modules/sinon/pkg/*


FROM  phusion/baseimage:0.10.0 as RunImage

# Use baseimage-docker's init system.
CMD   ["/sbin/my_init"]

COPY --from=BuildImage /var/www/node /var/www/node

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get update && apt-get install -y nodejs \
    && npm install yarn@1.9.4 -g \
    && npm install pm2 -g --no-optional \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && chmod -R 777 var/www/node /var/log/ \
    && useradd -m node \
    && mkdir /var/log/nodejs \
    && chown -R node:node /var/www/node /var/log/ \
    && mkdir /etc/service/pm2 \
    && chmod -R 777 /etc/service/pm2

# Open local port 3030
EXPOSE	3030

ADD ./scripts/pm2.sh /etc/service/pm2/run
RUN chmod -R 777 /etc/service/pm2