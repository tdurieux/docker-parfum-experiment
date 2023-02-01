FROM ubuntu:20.04 as build
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y curl bash && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs gcc g++ make libpixman-1-dev libcairo2-dev libpango1.0-dev libjpeg8-dev libgif-dev jq && rm -rf /var/lib/apt/lists/*;

WORKDIR /double-take/api
COPY /api/package.json .
RUN npm install --production && npm cache clean --force;

WORKDIR /double-take/frontend
COPY /frontend/package.json .
RUN npm install && npm cache clean --force;

WORKDIR /double-take/api
COPY /api/server.js .
COPY /api/src ./src

WORKDIR /double-take/frontend
COPY /frontend/src ./src
COPY /frontend/public ./public
COPY /frontend/.env.production /frontend/vue.config.js /frontend/babel.config.js /frontend/.eslintrc.js ./

RUN npm run build
RUN mv dist /tmp/dist && rm -r * && mv /tmp/dist/* .

WORKDIR /
RUN mkdir /.storage
RUN ln -s /.storage /double-take/.storage

WORKDIR /double-take
RUN npm install nodemon -g && npm cache clean --force;
COPY /.build/entrypoint.sh .

FROM ubuntu:20.04
COPY --from=build . .
ENV NODE_ENV=production
WORKDIR /double-take
ENTRYPOINT ["/bin/bash", "./entrypoint.sh"]