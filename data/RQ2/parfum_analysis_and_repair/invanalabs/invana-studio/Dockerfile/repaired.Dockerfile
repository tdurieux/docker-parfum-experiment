# Multi stage docker build

## stage1: build react
FROM node:12 as react-build
WORKDIR /code
COPY . ./

RUN npm set progress=false && \
    npm config set depth 0 && \
    npm install && \
    npm cache clean --force
# just to make sure only clean code goes to build
RUN ./node_modules/.bin/eslint src/**/*.js
RUN npm run-script build --production

# stage2: deploy to nginx