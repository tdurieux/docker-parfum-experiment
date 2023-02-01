FROM node:current-alpine3.12

# Copy script
COPY webserver /webserver

# Install dependencies
WORKDIR /webserver

RUN npm install && npm cache clean --force;

# Expose command
CMD npm start
