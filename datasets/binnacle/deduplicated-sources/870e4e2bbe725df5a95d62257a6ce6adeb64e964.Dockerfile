FROM node:10.15.1-alpine
## A slim image of rasa-ui with out postgres db. Expects postgres to be set up with env variables.
## docker build -f Dockerfile_slim . -t myimages/slim-rasa-ui


# Create app directory
WORKDIR /usr/src/app

# Installation
ADD . .
RUN npm install

EXPOSE 5001
CMD [ "npm", "start" ]
