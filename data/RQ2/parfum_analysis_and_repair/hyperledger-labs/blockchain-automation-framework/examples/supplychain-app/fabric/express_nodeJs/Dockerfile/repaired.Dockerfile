FROM node:10-alpine

#Get rest server endpoint
ENV API_URL=changeMe
ENV PORT=3000
#copy app
COPY . ./app

#Set working directory and copy package files over for
WORKDIR /app

#install dependencies
RUN npm install && npm cache clean --force;

EXPOSE ${PORT}
CMD [ "node", "app.js" ]
