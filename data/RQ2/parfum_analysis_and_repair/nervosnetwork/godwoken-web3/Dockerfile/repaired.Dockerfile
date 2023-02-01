FROM node:14-bullseye

COPY . /godwoken-web3/.
RUN cd /godwoken-web3 && yarn && yarn build

RUN npm install pm2 -g && npm cache clean --force;

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install --no-install-recommends curl -y \
 && apt-get install --no-install-recommends jq -y \
 && apt-get clean \
 && echo "Finished installing dependencies" && rm -rf /var/lib/apt/lists/*;

EXPOSE 8024 3000
