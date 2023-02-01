FROM node:12-buster-slim

# Update the OS and install any OS packages needed.
RUN apt-get update -y && apt-get install --no-install-recommends -y git autoconf libtool python3 build-essential && rm -rf /var/lib/apt/lists/*;

# Clone the Bitcore repository
WORKDIR /home/safeuser
# RUN git clone https://github.com/christroutner/slpserve
RUN git clone https://github.com/fountainhead-cash/slpserve
WORKDIR /home/safeuser/slpserve
RUN npm install && npm cache clean --force;
COPY env .env

CMD ["npm", "start"]
