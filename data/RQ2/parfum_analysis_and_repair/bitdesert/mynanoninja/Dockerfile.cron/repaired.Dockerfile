FROM node:14

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install && npm cache clean --force;
# If you are building your code for production
# RUN npm ci --only=production

RUN npm install pm2 -g && npm cache clean --force;

# Bundle app source
COPY . .

EXPOSE 3000
CMD [ "pm2-runtime", "ecosystem.json", "--only", "CRON" ]
#CMD [ "node", "bin/www" ]