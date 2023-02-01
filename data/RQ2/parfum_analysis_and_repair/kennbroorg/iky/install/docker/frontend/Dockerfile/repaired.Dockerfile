FROM node:14

# Create app directory
WORKDIR /app

COPY frontend/package*.json ./

# Install app dependencies
RUN npm install && npm cache clean --force;

COPY frontend .

RUN sed -ie '/"start":/c\"start": "ng serve --host 0.0.0.0 --disableHostCheck",' package.json

EXPOSE 4200
CMD [ "npm", "start"]
