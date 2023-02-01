# pull official base image
FROM node:14.15.1-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install && npm cache clean --force;
RUN npm install react react-dom --no-save --silent && npm cache clean --force;

# add app
COPY . ./

# start app
CMD ["npm", "start"]


