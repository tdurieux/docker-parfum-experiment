FROM node:6.9.1-slim

EXPOSE 3000
WORKDIR /app

RUN npm install -g yarn@0.16 && npm cache clean --force;

RUN apt-get update && apt-get install --no-install-recommends python make g++ g++-4.8 -y && rm -rf /var/lib/apt/lists/*;

CMD npm start
