FROM comum/pg-dispatcher:latest AS dispatcher-env

FROM node:10.15-jessie

RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY --from=dispatcher-env /usr/local/bin/pg-dispatcher /usr/local/bin/

WORKDIR /usr/app

COPY . .

RUN npm install && npm cache clean --force;
