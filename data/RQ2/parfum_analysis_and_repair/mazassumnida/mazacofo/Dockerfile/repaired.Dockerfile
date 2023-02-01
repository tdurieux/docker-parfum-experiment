FROM node:14
WORKDIR /home/ubuntu/node
COPY package*.json ./
RUN npm install -g && npm cache clean --force;
COPY . .
CMD ["npm", "start"]
EXPOSE 2021
