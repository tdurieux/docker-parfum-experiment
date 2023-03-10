# Setup and build the client

FROM node:11.7-alpine as client

WORKDIR /usr/app/client/
COPY client/package*.json ./
RUN npm install -qy && npm cache clean --force;
COPY client/ ./
RUN npm run build


# Setup the server

FROM node:9.4.0-alpine

WORKDIR /usr/app/
COPY --from=client /usr/app/client/build/ ./client/build/

WORKDIR /usr/app/server/
COPY server/package*.json ./
RUN npm install -qy && npm cache clean --force;
COPY server/ ./

ENV PORT 8000

EXPOSE 8000

CMD ["npm", "start"]
