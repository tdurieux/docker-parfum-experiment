FROM node:carbon

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./
# COPY start.sh ./
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 80

CMD [ "npm","start" ]