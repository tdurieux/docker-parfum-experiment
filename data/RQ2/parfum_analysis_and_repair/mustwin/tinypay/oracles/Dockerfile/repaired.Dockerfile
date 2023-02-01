FROM node:argon

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
COPY . /usr/src/app
COPY scripts/run.sh /usr/src/app/

RUN npm install && npm cache clean --force;

EXPOSE 80

CMD ["./run.sh"]
