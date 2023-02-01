FROM node:alpine3.13

# Set env VERSION
ENV VERSION 1.0.0

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY chatbot-conversational_AI/update-bot/app/package*.json ./

RUN npm install && npm cache clean --force;

# Bundle app source
COPY chatbot-conversational_AI/update-bot/app ./

EXPOSE 3000

CMD [ "npm", "start" ]
