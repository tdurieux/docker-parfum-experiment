FROM node:12-alpine

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 CMD [ "/bin/sh", "-c", "wget -O- http://localhost:3000/index.html | grep TRM" ]

RUN mkdir -p /usr/src/app \
 && adduser -s /bin/false -D app \
 && chown app:app /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY package.json yarn.lock /usr/src/app/
RUN yarn install && yarn cache clean;
COPY . /usr/src/app
RUN cp src/config.example.js src/config.js
CMD ["/usr/local/bin/yarn", "start"]
