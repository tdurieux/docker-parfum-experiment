FROM node

WORKDIR /src

COPY package.json .
RUN npm i && npm cache clean --force;
RUN npm install forever -g && npm cache clean --force;

COPY . .

EXPOSE 8080

CMD ["forever", "./server/server.js"]
