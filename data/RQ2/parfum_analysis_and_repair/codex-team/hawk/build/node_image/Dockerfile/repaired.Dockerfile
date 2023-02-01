FROM node:carbon

WORKDIR /var/www

RUN npm install && npm cache clean --force;

EXPOSE 3000
EXPOSE 8070
CMD [ "npm", "start" ]