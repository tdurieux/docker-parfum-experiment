FROM node:14-alpine
WORKDIR /usr
COPY package.json ./
COPY tsconfig.json ./
COPY src ./src
RUN npm install && npm cache clean --force;
RUN npm run build

FROM node:14-alpine
WORKDIR /usr
COPY package.json ./
RUN npm install --only=production && npm cache clean --force;
COPY --from=0 /usr/dist .
RUN npm install pm2 -g && npm cache clean --force;
EXPOSE 80
CMD ["pm2-runtime","index.js"]