FROM node:13
ENV NODE_ENV production
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --production && npm cache clean --force;
COPY . .
EXPOSE 5000
CMD npm start