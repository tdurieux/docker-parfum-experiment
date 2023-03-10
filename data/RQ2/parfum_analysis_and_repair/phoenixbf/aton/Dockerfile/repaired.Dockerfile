FROM node:14

# Create main ATON folder
WORKDIR /aton

# Install app dependencies
COPY package*.json ./

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

#EXPOSE 8080
CMD [ "node", "services/ATON.service.main.js" ]

