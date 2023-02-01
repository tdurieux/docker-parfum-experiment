FROM node:14-alpine
WORKDIR /opt/app
ADD package.json package.json
RUN npm install && npm cache clean --force;
ADD . .
RUN npm run build
RUN npm prune --production
CMD ["node", "./dist/main.js"]