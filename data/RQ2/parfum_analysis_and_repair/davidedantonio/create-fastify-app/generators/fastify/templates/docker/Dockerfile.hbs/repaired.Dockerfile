FROM node:latest
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;
COPY . /usr/src/app
EXPOSE {{port}}
RUN npm -g install create-fastify-app && npm cache clean --force;
CMD [ "fastify-app", "run" ]