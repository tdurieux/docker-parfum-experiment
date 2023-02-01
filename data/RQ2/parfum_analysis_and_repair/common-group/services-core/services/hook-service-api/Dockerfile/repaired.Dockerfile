FROM comum/pg-dispatcher:latest AS dispatcher-env

FROM node:14.14-stretch

RUN apt-get update
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY --from=dispatcher-env /usr/local/bin/pg-dispatcher /usr/local/bin/

WORKDIR /usr/app

COPY . .

RUN npm install && npm cache clean --force;
CMD npm start server.js
