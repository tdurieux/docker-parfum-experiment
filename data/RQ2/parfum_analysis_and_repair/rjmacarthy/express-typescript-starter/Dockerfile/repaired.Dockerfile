FROM node:14.17.0
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install && npm cache clean --force;
RUN npm run build
ENV NODE_ENV docker
EXPOSE 3000
CMD [ "npm", "run", "start" ]