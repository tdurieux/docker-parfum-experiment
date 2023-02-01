FROM node:latest

# set working directory
RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# add environment variables
ARG NODE_ENV
ARG REACT_APP_USERS_SERVICE_URL
ARG REACT_APP_EXERCISES_SERVICE_URL
ARG REACT_APP_SCORES_SERVICE_URL
ARG REACT_APP_API_GATEWAY_URL
ENV NODE_ENV $NODE_ENV
ENV REACT_APP_USERS_SERVICE_URL $REACT_APP_USERS_SERVICE_URL
ENV REACT_APP_EXERCISES_SERVICE_URL $REACT_APP_EXERCISES_SERVICE_URL
ENV REACT_APP_SCORES_SERVICE_URL $REACT_APP_SCORES_SERVICE_URL
ENV REACT_APP_API_GATEWAY_URL $REACT_APP_API_GATEWAY_URL

# install and cache app dependencies
ADD package.json /usr/src/app/package.json
RUN npm install --silent && npm cache clean --force;
RUN npm install pushstate-server -g --silent && npm cache clean --force;
RUN npm install react-scripts@1.0.15 -g --silent && npm cache clean --force;

# add app
ADD . /usr/src/app

# build react app
RUN npm run build

# start app
CMD ["pushstate-server", "build", "3000"]
