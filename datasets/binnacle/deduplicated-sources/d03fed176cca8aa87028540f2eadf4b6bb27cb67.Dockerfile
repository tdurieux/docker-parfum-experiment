FROM node:8

# Create app directory
WORKDIR /usr/src/app

# Environment variables
ENV STOR_MONGO_URI mongodb://localhost:27017/icy
ENV STOR_PORT 8080
ENV STOR_PASSWORD password
ENV STOR_CORS_ENABLED 0

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "npm", "start" ]

