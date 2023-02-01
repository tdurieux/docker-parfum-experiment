FROM node:13.12.0-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
RUN npm install && npm cache clean --force;
RUN npm install react-scripts@4.0.0 -g && npm cache clean --force;

# add app
COPY . ./

# start app
CMD ["npm", "start"]
