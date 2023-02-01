FROM node:8.16.1-alpine
WORKDIR /app
COPY . /app
RUN npm install && npm cache clean --force;
EXPOSE 5000
CMD node index.js

#ENTRYPOINT ["node", "index.js"]
#COPY package.json /app
