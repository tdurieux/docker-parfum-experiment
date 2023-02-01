FROM node:14

# Create app directory
RUN mkdir -p /code
WORKDIR /code

# Install app dependencies
COPY package.json /code/
COPY package-lock.json /code/
RUN npm install && npm cache clean --force;

# Bundle app source
COPY ./src /code/src

EXPOSE 3001
CMD [ "npm", "start" ]