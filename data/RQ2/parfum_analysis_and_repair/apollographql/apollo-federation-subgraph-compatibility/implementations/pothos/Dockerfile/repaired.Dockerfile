FROM node:14-alpine
WORKDIR /web
COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;
COPY index.ts ./
EXPOSE 4001
USER node
CMD npm start
