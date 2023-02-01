FROM node:12-buster-slim

RUN apt-get update -y && apt-get install --no-install-recommends -y autoconf libtool git python3 build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/safeuser

RUN git clone https://github.com/fountainhead-cash/slpsockserve
WORKDIR /home/safeuser/slpsockserve
RUN npm install && npm cache clean --force;
COPY env .env

CMD ["npm", "start"]
