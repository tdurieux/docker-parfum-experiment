FROM node:14
#current node version is 14.16.1
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
#RUN npm run dev
EXPOSE 3000
ENTRYPOINT [ "npm", "start" ]
