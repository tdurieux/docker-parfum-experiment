FROM node:14

# create & set working directory
WORKDIR /app

# copy source files
COPY . /app

# install dependencies
RUN npm install && npm cache clean --force;

# start app
RUN npm run build
EXPOSE 3000
CMD npm run start
