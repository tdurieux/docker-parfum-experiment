FROM node:10-alpine

ENV PORT 3000

# Create app directory
RUN apk update && \
    apk add --no-cache nodejs npm git nano && \
    git clone https://github.com/punctuations/ac /ac
WORKDIR /ac

# Install app dependencies
RUN npm install && npm cache clean --force;

EXPOSE 3000

# CMD [ "npm", "run", "dev" ]