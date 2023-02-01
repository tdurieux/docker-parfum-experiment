FROM phusion/passenger-nodejs

RUN mkdir /home/app/webapp
RUN mkdir /home/app/logs

# nginx setup
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/nginx.conf
ADD ./docker/prod/static/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/prod/static/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD ./docker/prod/static/webapp-env.conf /etc/nginx/main.d/webapp-env.conf

# npm
RUN mkdir /home/app/static
RUN mkdir /home/app/static-build
WORKDIR /home/app/static-build
RUN apt-get update
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
RUN gem install sass
RUN npm install -g bower && npm cache clean --force;
RUN npm install -g gulp && npm cache clean --force;
ADD ./frontend/package.json /home/app/static-build
RUN npm install && npm cache clean --force;
ADD ./frontend/bower.json /home/app/static-build
RUN bower install --allow-root
ADD ./frontend /home/app/static-build
RUN gulp build

ADD ./docker/prod/static/copy_files.sh /etc/my_init.d/copy_files.sh

# ending
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
