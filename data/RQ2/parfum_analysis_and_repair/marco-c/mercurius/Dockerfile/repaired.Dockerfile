FROM node:latest

# Install redis
RUN apt-get update && apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;

# Install Mercurius
RUN mkdir /src
WORKDIR /src
COPY package.json /src
RUN npm install && npm cache clean --force;

COPY . /src
RUN npm run build

EXPOSE 4000

RUN chmod +x start.sh
CMD ./start.sh
