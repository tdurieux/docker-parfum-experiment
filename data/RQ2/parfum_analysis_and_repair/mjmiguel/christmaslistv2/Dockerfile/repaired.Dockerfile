FROM node:12.18.1
WORKDIR /usr/src/app
COPY ./ /usr/src/app
RUN npm install && npm cache clean --force;
RUN npm run build
EXPOSE 3000
ENTRYPOINT [ "npm", "start" ]