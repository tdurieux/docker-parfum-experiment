FROM node:16.13.0

RUN mkdir /root/web

ADD web.tar.gz /root/web
RUN npm i -g pm2 && npm cache clean --force;
RUN cd /root/web/ && npm i --production && npm cache clean --force;
RUN cd /root/web/ && npm i typescript --save-dev && npm cache clean --force;
RUN cd /root/web/ && make build.prod

ADD loader.sh /usr/local/bin/loader.sh
RUN chmod +x /usr/local/bin/loader.sh
CMD ["/usr/local/bin/loader.sh"]