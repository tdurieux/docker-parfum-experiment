FROM node:10.9.0 as builder

WORKDIR /srv/unbabel

# Copy files necessary to run NPM CI and install
COPY package-lock.json package.json ./

# Install NPM dependencies
RUN npm ci

# Copy files necessary to build assets
COPY project project
COPY .babelrc jest.config.js postcss.config.js webpack.config.js ./

EXPOSE 8081
CMD ["npm", "run", "dev"]