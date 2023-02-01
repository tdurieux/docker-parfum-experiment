FROM node:12-buster-slim

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
# set default node environment
ENV NODE_ENV development

COPY . /usr/src/app

# Install app dependencies
RUN npm install && npm cache clean --force;

EXPOSE 5000

RUN npm install -g forever && npm cache clean --force;

CMD forever -c "npm start" ./
