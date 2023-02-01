FROM node:12-alpine

COPY trm-api /usr/src/trm-api

RUN mkdir -p /usr/src/app \
 && adduser -s /bin/false -D app \
 && chown app:app /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY data-generator/package.json data-generator/package-lock.json /usr/src/app/
RUN npm install && npm cache clean --force;
COPY data-generator /usr/src/app/
ENTRYPOINT ["/usr/local/bin/npm", "run", "generator"]
