FROM mhart/alpine-node:12

RUN node -v
RUN npm -v

RUN apk add --update \
    git \
    openssh \
    python \
    python-dev \
    build-base \
  && rm -rf /var/cache/apk/*

RUN mkdir -p $HOME/service/toga
WORKDIR $HOME/service/toga

COPY package.json ./

RUN npm install --production && npm cache clean --force;

COPY . ./

ENV NODE_ENV=production
EXPOSE 8080
CMD npm start
