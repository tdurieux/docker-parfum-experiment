FROM node:8.1-alpine

EXPOSE 3000

WORKDIR /src

RUN apk -U upgrade \
  && apk add \
     ca-certificates \
     file \
     git \
     su-exec \
     tini \
  && npm install -g nodemon gulp-cli \
  && update-ca-certificates \
  && rm -rf /tmp/* /var/cache/apk/* && npm cache clean --force;

# Copy files
COPY . /src

# Install app dependencies
RUN npm install && npm cache clean --force;

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Run node server
CMD ["node", "mananciais.js", "serve"]
