FROM node:14 AS build

COPY ./mwdb/web /app
COPY ./docker/plugins /plugins

RUN cd /app \
    && npm install --unsafe-perm . $(find /plugins -name 'package.json' -printf "%h\n" | sort -u) \
    && CI=true npm run build \
    && npm cache clean --force

ENV PROXY_BACKEND_URL http://mwdb.:8080

WORKDIR /app
CMD ["npm", "run", "start"]