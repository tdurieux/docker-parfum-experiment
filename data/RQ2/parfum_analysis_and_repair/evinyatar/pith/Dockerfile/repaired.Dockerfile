FROM node:16
WORKDIR /usr/src/app

RUN apt-get update && apt-get install --no-install-recommends -y libavahi-compat-libdnssd-dev libvips-dev && rm -rf /var/lib/apt/lists/*;

COPY package*.json ./
COPY webui/package*.json ./webui/
RUN npm install && npm cache clean --force;
RUN npm install --prefix ./webui && npm cache clean --force;

COPY . .

RUN npm run build

EXPOSE 3333

CMD [ "node", "built/app.js" ]
