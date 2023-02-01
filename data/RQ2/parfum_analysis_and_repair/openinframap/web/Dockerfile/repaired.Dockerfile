FROM node:12
RUN mkdir -p /app
WORKDIR /app
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 8080
ENTRYPOINT ["npm", "start"]
