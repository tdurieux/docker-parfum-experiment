FROM node:18
WORKDIR /app
COPY server/package.json .
RUN npm i && npm cache clean --force;
COPY server/main.js .
ENV ADMIN_TOKEN=test
CMD node main.js
