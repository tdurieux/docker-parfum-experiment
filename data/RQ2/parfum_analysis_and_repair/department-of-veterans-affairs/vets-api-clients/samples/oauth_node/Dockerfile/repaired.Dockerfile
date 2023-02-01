FROM node:16

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Bundle app source
COPY index.js ./
COPY db ./db/
COPY views ./views/
COPY .env ./

EXPOSE 8080

CMD [ "nodejs", "index.js" ]
