FROM node:14 as builder

WORKDIR /srv

COPY package.json yarn.lock ./
RUN npm install --legacy-peer-deps && npm cache clean --force;
RUN npm config set unsafe-perm true
RUN npm install -g gatsby-cli && npm cache clean --force;
COPY . .
ENTRYPOINT [ "sh", "./entrypoint.sh" ]
