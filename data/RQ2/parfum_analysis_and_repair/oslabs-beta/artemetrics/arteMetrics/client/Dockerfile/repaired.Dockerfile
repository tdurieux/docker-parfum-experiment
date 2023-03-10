FROM node:10.15
ENV CI true
WORKDIR /usr/src/app
COPY . /usr/src/app/
RUN npm install && npm cache clean --force;
EXPOSE 8080
EXPOSE 3000
CMD ["npm", "run", "server"]
