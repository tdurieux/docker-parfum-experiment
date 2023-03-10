FROM node:14
#LTS at time of creation

WORKDIR /usr/logs

#create folder fo app
WORKDIR /usr/src/app

#Pull in the package defs
COPY package*.json ./

#Install the packages
RUN npm install && npm cache clean --force;
# could change to: RUN npm ci --only=production
# I don't understand pros/cons

#Bring the entire source (where dockerfile is located)
#Into the app directory we are now in
COPY . .

# Build the app
RUN npm run tsc

EXPOSE 8080
EXPOSE 3030

CMD ["node", "build/app.js"]
