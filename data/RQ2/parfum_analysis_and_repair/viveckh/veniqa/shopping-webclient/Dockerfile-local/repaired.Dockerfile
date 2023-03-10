FROM node:lts-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /app/package.json
RUN npm install && npm cache clean --force;
RUN npm install @vue/cli@3.7.0 -g && npm cache clean --force;

# start app
CMD ["npm", "run", "serve"]