FROM node:14-alpine
WORKDIR /opt/app
ADD package.json package.json
RUN npm install && npm cache clean --force;
ADD . .
ENV NODE_ENV production
RUN npm run build
RUN npm prune --production
CMD ["npm", "start"]
EXPOSE 3000