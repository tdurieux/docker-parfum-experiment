# docker build -t open-intelligence-front .
# docker run open-intelligence-front

FROM node:14-alpine

# Create app directory
WORKDIR /usr/src/app

# Install backend dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

# Install front end dependencies
WORKDIR /usr/src/app/front-end
RUN npm install && npm cache clean --force;

# Go back to root
WORKDIR /usr/src/app

# Port to access backend and front end
EXPOSE 4300 3000

# PM2 is used to run apps
RUN npm install -g pm2 && npm cache clean --force;

# define the command to run your app using CMD which defines your runtime
CMD ["pm2-runtime", "ecosystem.config.js"]
