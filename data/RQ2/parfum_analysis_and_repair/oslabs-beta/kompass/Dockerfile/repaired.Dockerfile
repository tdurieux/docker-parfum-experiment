FROM node:latest
WORKDIR /usr/src/app
RUN npm install -g webpack nodemon && npm cache clean --force;
COPY . /usr/src/app
RUN npm install && npm cache clean --force;
RUN npm run build
EXPOSE 3036
CMD ["npm", "start"]
