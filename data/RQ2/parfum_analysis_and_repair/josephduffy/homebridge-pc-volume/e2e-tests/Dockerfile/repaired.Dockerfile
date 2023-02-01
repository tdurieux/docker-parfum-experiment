FROM node:14

RUN mkdir /app
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;
COPY package-lock.json ./
RUN npm install -g --unsafe-perm homebridge@$(jq ".dependencies | .homebridge | .version" --raw-output < package-lock.json) && npm cache clean --force;

COPY config.json /root/.homebridge/config.json
COPY package/ ./

RUN npm install --global $(pwd) && npm cache clean --force;

CMD [ "homebridge" ]
