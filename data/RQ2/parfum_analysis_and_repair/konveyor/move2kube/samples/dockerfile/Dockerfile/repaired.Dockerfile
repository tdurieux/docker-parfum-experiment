FROM node:14
WORKDIR /app
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 8080
CMD ["npm", "run", "start"]
