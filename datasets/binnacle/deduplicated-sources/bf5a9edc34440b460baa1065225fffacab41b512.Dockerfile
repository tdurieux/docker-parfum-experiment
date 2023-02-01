FROM node:8.11

RUN mkdir /root/web

ADD web.tar.gz /root/web
RUN npm install -g pm2 --registry=https://registry.npm.taobao.org
RUN cd /root/web/ && npm install --registry=https://registry.npm.taobao.org

ARG GITHUB_CLIENT_ID=3b4281c5e54ffd801f85
ARG SERVE_PORT=8002

RUN cd /root/web/ && npm run build:prod

ADD loader.sh /usr/local/bin/loader.sh
RUN chmod +x /usr/local/bin/loader.sh
CMD ["/usr/local/bin/loader.sh"]