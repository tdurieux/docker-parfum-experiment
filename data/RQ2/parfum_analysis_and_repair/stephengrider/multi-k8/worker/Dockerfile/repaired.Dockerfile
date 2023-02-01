FROM node:alpine
WORKDIR "/app"
COPY package.json ./
RUN npm install && npm cache clean --force;
COPY . .

ENV REDIS_HOST=${REDIS_HOST}
ENV REDIS_PORT=${REDIS_PORT}

CMD ["npm", "run", "start"]