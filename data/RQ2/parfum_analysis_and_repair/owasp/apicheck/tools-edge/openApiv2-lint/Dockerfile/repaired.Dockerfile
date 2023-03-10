FROM node:14.0.0-alpine3.11

RUN apk update && \
    apk upgrade && \
    npm install --ignore-scripts -g oval && npm cache clean --force;

COPY linter.sh /bin

ENTRYPOINT ["linter.sh"]
