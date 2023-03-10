# pull official base image
# build environment
FROM node:14.15.1-alpine as build

# set node_modules directory
WORKDIR /app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
RUN npm i && npm cache clean --force

# Copies everything over to Docker environment & Run build
COPY . .
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html

# add the below line only if you are using React-Router