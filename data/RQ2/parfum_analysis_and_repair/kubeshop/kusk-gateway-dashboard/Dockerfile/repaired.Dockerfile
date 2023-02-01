# build environment
FROM node:16.14-buster as build
ARG SEGMENT_API_KEY
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN npm ci
COPY . ./
RUN REACT_APP_SEGMENT_API_KEY=${SEGMENT_API_KEY} npm run build

# production environment