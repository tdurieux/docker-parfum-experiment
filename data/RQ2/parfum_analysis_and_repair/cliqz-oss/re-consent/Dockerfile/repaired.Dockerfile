FROM node:9.6.1

WORKDIR /app/

COPY package.json /app/
COPY package-lock.json /app/

RUN npm install --silent && npm cache clean --force;

CMD npm run build
