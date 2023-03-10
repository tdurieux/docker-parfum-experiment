FROM node:12.19.1-alpine3.9

# Create app directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
RUN npm install && npm cache clean --force;
RUN npm install react-scripts@3.4.1 -g && npm cache clean --force;

# Bundle app source
COPY . ./

RUN cd server && npm install && npm cache clean --force;

EXPOSE 5000
CMD [ "npm", "start" ]
