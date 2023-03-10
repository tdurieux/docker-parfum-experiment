FROM node:12.18.3

# Create app directory
WORKDIR /usr/src/app

COPY . .
RUN npm install && npm cache clean --force;

VOLUME ./files

EXPOSE 4000
CMD [ "npm", "start" ]
