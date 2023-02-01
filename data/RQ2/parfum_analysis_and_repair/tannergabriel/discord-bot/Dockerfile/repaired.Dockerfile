FROM node:17.4.0

WORKDIR /usr/src/app

RUN apt-get update || : && apt-get install --no-install-recommends python -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

COPY package*.json ./

RUN npm ci

COPY . .

CMD [ "node", "index.js" ]