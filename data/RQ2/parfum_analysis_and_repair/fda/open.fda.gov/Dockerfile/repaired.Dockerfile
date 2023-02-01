FROM  node:14

ADD . /app
WORKDIR /app

EXPOSE 3000
RUN npm install npm -g && npm cache clean --force;
RUN npm ci
CMD ["npm","run","dev"]
