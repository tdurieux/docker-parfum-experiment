FROM node:latest

RUN mkdir /var/www/
ADD service.js /var/www/service.js
WORKDIR /var/www/
RUN npm install mysql

CMD ["node", "service.js"]
