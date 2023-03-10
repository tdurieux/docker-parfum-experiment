# pull official base image
FROM node:16.2.0-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install -g npm@7.14.0 --silent && npm cache clean --force;
RUN npm config set registry http://registry.npmjs.org/ && \
    npm --without-ssl --insecure install react-scripts -g --silent


# add app
COPY ./src/ui_controller ./

# start app
CMD ["npm", "start"]