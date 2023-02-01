FROM node:14
WORKDIR /usr/src/app
COPY . /usr/src/app/
RUN cd demo
RUN npm install && npm cache clean --force;
ENTRYPOINT ["npm", "start"]
EXPOSE 3000 4000