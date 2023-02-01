FROM node:10-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install camunda-external-task-client-js && npm cache clean --force;
RUN npm install dotenv --save && npm cache clean --force;
RUN npm install nodemailer && npm cache clean --force;
RUN npm install --production && npm cache clean --force;
COPY . .
CMD [ "node", "external-worker.js" ]
