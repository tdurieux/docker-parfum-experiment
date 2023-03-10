FROM node:latest

RUN npm install -g Haraka && npm cache clean --force;
RUN haraka -i /usr/local/haraka

RUN cd /usr/local/haraka && npm install haraka-plugin-mongodb clamscan cheerio && npm install node-libcurl --build-from-source && npm cache clean --force;

ADD ./config/smtp.ini /usr/local/haraka/config/smtp.ini
ADD ./config/plugins /usr/local/haraka/config/plugins
ADD ./config/host_list /usr/local/haraka/config/host_list

ADD ./config/mongodb.ini /usr/local/haraka/config/mongodb.ini

ADD ./plugins/safelinks.js /usr/local/haraka/plugins/safelinks.js
ADD ./config/safelinks.ini /usr/local/haraka/config/safelinks.ini

EXPOSE 25

CMD ["haraka", "-c", "/usr/local/haraka"]
