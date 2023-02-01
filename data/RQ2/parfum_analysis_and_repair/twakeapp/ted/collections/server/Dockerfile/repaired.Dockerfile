FROM node:12

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build

# App
EXPOSE 7250

# Monitoring (Prometheus)
EXPOSE 7251

ENTRYPOINT ["npm", "run", "start"]

