FROM node:12

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y gcc-multilib g++-multilib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsndfile1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

ARG NODE_CONFIG_ENV=default

ENV NODE_CONFIG_ENV=${NODE_CONFIG_ENV}
ENV NODE_ENV=production

CMD [ "npm", "start" ]