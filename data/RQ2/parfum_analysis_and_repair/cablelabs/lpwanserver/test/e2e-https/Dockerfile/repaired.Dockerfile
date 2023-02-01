FROM node:10.15

WORKDIR /usr/src

COPY package*.json ./
COPY app app
COPY development/config.json config.json
COPY test/e2e-https test/e2e-https
COPY test/networks test/networks
COPY test/lib test/lib
COPY lib lib
COPY certs certs

RUN npm install && npm cache clean --force;

# Prevent server from attempting to serve UI
ENV public_dir=""

CMD ["npm", "run", "test:e2e-https"]
