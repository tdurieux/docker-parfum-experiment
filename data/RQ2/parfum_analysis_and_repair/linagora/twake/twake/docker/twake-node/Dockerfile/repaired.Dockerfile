# Common node machine
FROM node:16-bullseye-slim as node-base

### Install dependancies

#Imagick
RUN apt-get update && apt-get install --no-install-recommends -y ghostscript && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y graphicsmagick && rm -rf /var/lib/apt/lists/*;

#Unoconv
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes unoconv libxml2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update && apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;
# upgrade unoconv
RUN wget -N https://raw.githubusercontent.com/dagwieers/unoconv/master/unoconv -O /usr/bin/unoconv
RUN chmod ugo+x /usr/bin/unoconv
RUN ln -s /usr/bin/python3 /usr/bin/python

#Docker mac issue
RUN apt-get update && apt-get install --no-install-recommends -y libc6 && rm -rf /var/lib/apt/lists/*;
RUN ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

# FFmpeg
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;

### Install Twake

WORKDIR /usr/src/app
COPY backend/node/package*.json ./

# Test Stage
FROM node-base as test

RUN npm install && npm cache clean --force;
COPY backend/node/ .

# Add frontend Stage
FROM node-base as with-frontend

ARG NODE_ENV=production

ENV NODE_ENV=development
RUN npm install && npm cache clean --force; #Install dev dependancies for build
COPY backend/node/ .
ENV NODE_ENV=${NODE_ENV}
RUN npm run build #Build in production mode
RUN rm -R node_modules
RUN npm install && npm cache clean --force; #Install prod dependancies after build

# Add frontend into node
ENV NODE_ENV=development
COPY frontend/ ../public_build/
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN cd ../public_build && yarn install --network-timeout 1000000000 && yarn cache clean;
RUN yarn global add webpack && yarn global add webpack-cli && yarn global add jest && yarn cache clean;
RUN cp ../public_build/src/app/environment/environment.ts.dist ../public_build/src/app/environment/environment.ts
ENV NODE_ENV=${NODE_ENV}
RUN cd ../public_build && yarn build && yarn cache clean;
RUN cd ../public_build && rm -R node_modules
RUN mv ../public_build/build/* public/; rm -R ../public_build

# Development Stage
FROM with-frontend as development

ENV NODE_ENV=development
RUN npm install -g pino-pretty && npm cache clean --force;
RUN npm install -g tsc-watch && npm cache clean --force;
RUN yarn install && yarn cache clean;
RUN ls
RUN ls public

CMD ["npm", "run", "dev"]



# Production Stage
FROM with-frontend as production

EXPOSE 3000
CMD ["npm", "run", "serve"]
