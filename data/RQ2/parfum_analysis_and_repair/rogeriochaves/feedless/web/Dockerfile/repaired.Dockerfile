FROM node:11

WORKDIR /app

COPY zdocker/package-20200420.json package.json
COPY zdocker/package-lock-20200420.json package-lock.json
RUN npm install && npm cache clean --force;

COPY zdocker/package-20200426.json package.json
COPY zdocker/package-lock-20200426.json package-lock.json
RUN npm install && npm cache clean --force;

COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;
COPY apply-patches.sh .
RUN npm run postinstall

COPY . .

ENV NODE_ENV=production
CMD npm run start
