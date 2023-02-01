FROM node:carbon

WORKDIR /app/spotify-service
COPY spotify-service/ .
RUN npm i && npm cache clean --force;
RUN npm run build

WORKDIR /app
WORKDIR /app/server
COPY server/ .
RUN npm i && npm cache clean --force;
ENTRYPOINT ["npm", "run" ,"start:prod"]
