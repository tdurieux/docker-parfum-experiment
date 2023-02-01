FROM node:8
RUN npm install -g gulp gulp-cli yarn && npm cache clean --force;
WORKDIR "/var/www/html/sugar"
ADD install.sh /install.sh
ENTRYPOINT ["/install.sh"]
