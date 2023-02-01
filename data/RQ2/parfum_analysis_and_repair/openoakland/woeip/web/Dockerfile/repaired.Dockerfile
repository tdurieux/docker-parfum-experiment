FROM node:16.14.0-alpine

# set working directory
WORKDIR /usr/src/app

# add `/app/node_modules/.bin` to $PATH
ENV PATH usr/src/app/node_modules/.bin:$PATH

# install app dependencies
COPY package*.json ./
RUN npm i && npm cache clean --force;
RUN mkdir -p node_modules/.cache && chmod -R 777 node_modules/.cache

# add app
COPY . .

EXPOSE 3000
# start app
CMD ["npm", "start"]
