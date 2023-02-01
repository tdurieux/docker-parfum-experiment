FROM node:10

RUN npm install -g pm2 && npm cache clean --force;

WORKDIR /var/www/app

CMD ["/bin/bash"]
