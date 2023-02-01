FROM node:latest

# Install redis
RUN apt-get update && apt-get install -y redis-server

# Install Mercurius
RUN mkdir /src
WORKDIR /src
COPY package.json /src
RUN npm install

COPY . /src
RUN npm run build

EXPOSE 4000

RUN chmod +x start.sh
CMD ./start.sh
