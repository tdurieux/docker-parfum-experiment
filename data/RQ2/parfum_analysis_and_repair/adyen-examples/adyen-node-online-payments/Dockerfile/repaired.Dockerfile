FROM node:16-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

# Copy the source files into the image
COPY . .

CMD [ "npm", "start" ]
