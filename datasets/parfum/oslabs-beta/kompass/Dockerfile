FROM node:latest
WORKDIR /usr/src/app
RUN npm install -g webpack nodemon
COPY . /usr/src/app
RUN npm install
RUN npm run build
EXPOSE 3036
CMD ["npm", "start"]
