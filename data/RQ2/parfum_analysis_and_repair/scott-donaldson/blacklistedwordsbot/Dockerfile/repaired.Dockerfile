FROM node:15.3.0-buster

RUN mkdir -p /bot
WORKDIR /bot

RUN npm install pm2 -g && npm cache clean --force;

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential \
    wget \
    python3 \
    make \
    gcc \
    libc6-dev && rm -rf /var/lib/apt/lists/*;
RUN npm install node-gyp -g && npm cache clean --force;

COPY package.json /bot
RUN npm install && npm cache clean --force;

COPY . /bot
#ENV TOKEN=YOURTOKENHERE

CMD ["pm2-runtime", "index.js"]