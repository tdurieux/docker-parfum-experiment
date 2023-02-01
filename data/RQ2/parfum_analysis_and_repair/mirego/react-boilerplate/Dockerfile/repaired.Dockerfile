FROM node:12.14.1-alpine3.9

WORKDIR /opt/app

RUN npm install -g serve && npm cache clean --force;

COPY package.json package-lock.json ./

COPY scripts ./scripts

RUN npm ci --no-audit --no-color --unsafe-perm

COPY . .

ENTRYPOINT ["./scripts/docker-entrypoint.sh"]
