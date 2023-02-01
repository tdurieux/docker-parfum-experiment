# Stage 1 - the build process
FROM node:16 as build-deps
WORKDIR /usr/src/app
ADD package.json ./
ADD package-lock.json ./
RUN npm ci
ADD styles ./styles
ADD coffee ./coffee
ADD .babelrc ./
ADD build.js ./
RUN npm run build

# Stage 2 - the environment