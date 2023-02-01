FROM node:lts-slim

# Install system dependencies
RUN npm install -g pm2 nodemon && npm cache clean --force;

# App setup
WORKDIR /home/src/beetube

COPY ./ ./

RUN npm install && npm cache clean --force;

CMD [ "pm2-runtime", "npm", "--", "start" ]
