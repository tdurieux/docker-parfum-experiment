FROM nginx

RUN apt-get update -qq && apt-get -y --no-install-recommends install apache2-utils && rm -rf /var/lib/apt/lists/*;

ENV APP_DIR /var/www

WORKDIR $APP_DIR

RUN mkdir $APP_DIR/log

ADD public public/

ADD dockerize/nginx.conf /etc/nginx/nginx.conf

CMD [ "nginx", "-g", "daemon off;" ]
