FROM node:lts-alpine
WORKDIR /usr/src/fosscord-cdn
COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 3003
CMD ["node", "dist/"]