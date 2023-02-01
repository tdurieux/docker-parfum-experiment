FROM node:16.15
WORKDIR /app
COPY . .
RUN npm install && npm cache clean --force;
CMD ["npm", "start"]
