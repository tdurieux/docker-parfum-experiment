# pull official base image
FROM node:13.12.0-alpine

# set working directory
WORKDIR /platon_frontend

# add `/app/node_modules/.bin` to $PATH
ENV PATH /platon_frontend/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN apk add --no-cache git
RUN npm install && npm cache clean --force;
RUN npm install react-scripts@3.4.1 -g && npm cache clean --force;

# add app
COPY ./ ./

EXPOSE 3000

# start app
CMD ["npm", "start"]
