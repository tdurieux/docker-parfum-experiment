FROM okteto/node:14

WORKDIR /usr/src

ADD package.json .
RUN npm install && npm cache clean --force;

COPY . /usr/src/

RUN npm run build

EXPOSE 8888

CMD npm start