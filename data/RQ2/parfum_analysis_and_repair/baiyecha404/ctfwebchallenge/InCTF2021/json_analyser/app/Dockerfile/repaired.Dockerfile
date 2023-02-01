FROM node:14

# Create app directory
WORKDIR /app

COPY package*.json ./

RUN npm install -g nodemon && npm cache clean --force;

RUN npm install && npm cache clean --force;

COPY . .

RUN chmod +x ./run.sh
RUN ./run.sh

EXPOSE 8080
CMD [ "nodemon", "--ignore", "package.json"]

