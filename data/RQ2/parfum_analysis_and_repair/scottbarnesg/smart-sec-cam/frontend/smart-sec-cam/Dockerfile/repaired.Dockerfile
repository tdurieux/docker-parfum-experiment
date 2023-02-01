FROM node:16-alpine

WORKDIR /frontend
RUN mkdir -p certs

COPY . .

RUN npx browserslist@latest --update-db

RUN npm install && npm cache clean --force;
RUN npm update
RUN npm audit fix || true
RUN npm install -g serve && npm cache clean --force;
RUN npm run build

CMD ["serve", "-s", "build", "-l", "3000", "--ssl-cert", "./certs/sec-cam-server.cert", "--ssl-key", "./certs/sec-cam-server.key"]