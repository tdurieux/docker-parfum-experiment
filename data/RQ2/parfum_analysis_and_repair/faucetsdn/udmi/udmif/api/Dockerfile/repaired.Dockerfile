FROM node:16.13.2

ENV PORT 4300

RUN apt-get update && apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY package*.json ./
COPY tsconfig.json .
COPY src src

RUN npm install && npm cache clean --force;

EXPOSE $PORT

CMD ["npm", "start"]
