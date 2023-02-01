FROM node:carbon

WORKDIR /app/spotify-service
COPY spotify-service/ .
RUN npm i && npm cache clean --force;
RUN npm run build

WORKDIR /app/client
COPY client/ .
RUN npm i && npm cache clean --force;
ENTRYPOINT ["npm", "start"]
