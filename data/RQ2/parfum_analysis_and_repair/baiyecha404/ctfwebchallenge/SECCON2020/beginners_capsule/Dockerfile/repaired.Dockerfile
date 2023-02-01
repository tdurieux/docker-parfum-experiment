FROM node:14-alpine

RUN apk add --no-cache build-base libseccomp-dev git python3 && \
    npm install roryrjb/node-seccomp typescript ts-node @types/node && npm cache clean --force;

ADD tsconfig.json /

