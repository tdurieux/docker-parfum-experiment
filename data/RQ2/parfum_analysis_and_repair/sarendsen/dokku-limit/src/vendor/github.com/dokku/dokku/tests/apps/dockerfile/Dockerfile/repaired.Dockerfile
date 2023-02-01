FROM node:4

EXPOSE 3001/udp
EXPOSE  3000/tcp
EXPOSE 3003

COPY . /var/www/html
WORKDIR /var/www/html
RUN npm install && npm cache clean --force;

CMD npm start
