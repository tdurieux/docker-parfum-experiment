###########
# BUILDER #
###########

# base image
FROM node:13.10.1-alpine as builder

# set working directory
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /usr/src/app/package.json
COPY package-lock.json /usr/src/app/package-lock.json
RUN npm ci
RUN npm install react-scripts@3.4.0 -g --silent && npm cache clean --force;


# set environment variables
ARG REACT_APP_BACKEND_SERVICE_URL
ENV REACT_APP_BACKEND_SERVICE_URL $REACT_APP_BACKEND_SERVICE_URL
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

# create build
COPY . /usr/src/app
RUN npm run build


#########
# FINAL #
#########

# base image
FROM nginx:1.17.9-alpine

# update nginx conf
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/aws/default.conf /etc/nginx/conf.d/default.conf

# copy static files
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

# expose port
EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]
