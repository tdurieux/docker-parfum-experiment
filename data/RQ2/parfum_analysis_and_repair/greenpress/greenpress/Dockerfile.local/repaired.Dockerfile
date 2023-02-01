FROM node:15.14
COPY . .
ENV NODE_ENV=development
RUN npm install --unsafe-perm && npm cache clean --force;
RUN npm run build
RUN npm i -g pm2 && npm cache clean --force;
