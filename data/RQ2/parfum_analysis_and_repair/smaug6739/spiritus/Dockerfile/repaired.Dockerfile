FROM node:latest

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY package.json /usr/src/app/

RUN npm install && npm cache clean --force;

COPY . /usr/src/app

RUN chmod +x /usr/src/app/wait-for-it.sh /usr/src/app/entrypoint.sh


ENTRYPOINT ["bash","/usr/src/app/entrypoint.sh"]

CMD ["npm", "start"]