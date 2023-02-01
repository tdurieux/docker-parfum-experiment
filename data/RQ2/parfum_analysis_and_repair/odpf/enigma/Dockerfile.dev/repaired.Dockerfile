FROM node:16.3.0
ENV NEW_RELIC_HOME ./src
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 8000
CMD ["npm", "run", "dev"]
