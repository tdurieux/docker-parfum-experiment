FROM node:12.22.10
ENV NODE_ENV=production

WORKDIR /app
COPY ["src/*","./"]
RUN npm install && npm cache clean --force;
COPY . .

CMD [ "node", "server.js" ]