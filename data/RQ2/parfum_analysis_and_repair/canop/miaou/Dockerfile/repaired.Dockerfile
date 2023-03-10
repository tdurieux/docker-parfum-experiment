#
# Dockerfile for Miaou application
#

FROM node:10

USER root
RUN mkdir -p /var/www/miaou
WORKDIR /var/www/miaou

# NPM install (this is done before copying the whole application, in order to be cached)
COPY package.json /var/www/miaou/
RUN yarn add gulp && yarn cache clean;
RUN yarn && yarn cache clean;

# Copy and build application
COPY . /var/www/miaou/
RUN yarn run gulp build && yarn cache clean;

# Define exposable ports
EXPOSE 8204

# Define default command
CMD ["node", "--use_strict", "main.js"]
