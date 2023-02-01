FROM mhart/alpine-node:latest

WORKDIR /usr/src/app

ENV PORT 8080

COPY package*.json ./

RUN npm install --only=production && npm cache clean --force;

# Copy the local code to the container
COPY . .


# Start the service
CMD npm start