FROM node:16-alpine

WORKDIR /app

# terraform deps
RUN apk add --no-cache terraform --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add --no-cache git ruby ruby-dev docker-cli build-base openssh
RUN gem install json

# node modules
COPY package.json yarn.lock /app/
RUN yarn --frozen-lockfile

# masterchat dev
RUN git clone https://github.com/holodata/masterchat /masterchat && cd /masterchat && git switch dev && yarn install --frozen-lockfile && yarn build && yarn link && yarn cache clean;
RUN yarn link masterchat && yarn cache clean;

# build app
COPY tsconfig.json /app/
COPY src /app/src
RUN yarn build && yarn link && yarn cache clean;

# terraform init
# COPY tf /app/tf
# WORKDIR /app/tf
# RUN terraform init -no-color -input=false
# WORKDIR /app

CMD ["honeybee", "worker"]
