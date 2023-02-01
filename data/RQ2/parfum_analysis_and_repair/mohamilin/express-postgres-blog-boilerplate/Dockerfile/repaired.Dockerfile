FROM node:14

# Create app directory
RUN mkdir -p /usr/src/node-app && rm -rf /usr/src/node-app
RUN chmod -R 777 /usr/src/node-app

WORKDIR /usr/src/node-app

# Copy code
COPY package.json /usr/src/node-app/

COPY . .

RUN npm install -g nodemon && npm cache clean --force;
RUN npm install && npm cache clean --force;
# This is our secret sauce
RUN git clone https://github.com/vishnubob/wait-for-it.git

ENV NODE_ENV develoment
# Run config

EXPOSE 3000
