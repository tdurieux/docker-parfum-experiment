FROM treehouses/node

WORKDIR /ng-app

COPY package.json ./

RUN apk add --no-cache --update \
    python3 \
    build-base \
    jq

RUN npm i --silent && npm cache clean --force;