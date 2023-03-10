FROM node:14
ENV NODE_ENV production
WORKDIR /usr/src/app

COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]

RUN apt-get install -y --no-install-recommends make gcc g++ python && \
  npm install --production && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN npm install pm2 -g && mv node_modules ../ && npm cache clean --force;
COPY . ./
EXPOSE 3007
CMD ["pm2-runtime","bin/www"]


# FROM node:10.13-alpine
# ENV NODE_ENV production
# WORKDIR /usr/src/app

# COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]

# RUN apk add --no-cache make gcc g++ python libc6-compat && \
#   npm install --production

# RUN npm install pm2 -g && mv node_modules ../
# COPY . ./
# EXPOSE 3007
# CMD ["pm2-runtime","bin/www"]
