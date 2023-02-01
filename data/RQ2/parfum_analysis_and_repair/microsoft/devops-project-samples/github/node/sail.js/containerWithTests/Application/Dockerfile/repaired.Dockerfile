FROM node:8
LABEL maintainer="Azure App Service Container Images <appsvc-images@microsoft.com>"

# Create app directory
WORKDIR /app

# Bundle app source
COPY . .
RUN npm install && npm cache clean --force;

EXPOSE 3000 80
CMD [ "npm", "start" ]
