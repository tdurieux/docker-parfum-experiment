FROM jelastic/nodejs:14.16.0-npm
RUN yum install -y nginx && yum clean all && rm -rf /var/cache/yum
WORKDIR /app
ADD ./frontend/dist /frontend
ADD ./backend ./docker_init.sh ./nginx /app/
RUN cp /app/artipub.conf /etc/nginx/conf.d/artipub.conf
RUN npm install && npm cache clean --force;
RUN npm run build-nomap

EXPOSE 3000 8000
CMD /app/docker_init.sh

