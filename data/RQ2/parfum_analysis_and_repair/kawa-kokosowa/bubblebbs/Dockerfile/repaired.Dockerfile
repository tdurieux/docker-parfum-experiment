FROM alpine
MAINTAINER Kawa Kokosowa <kawa.kokosowa@gmail.com>

# update!
RUN apk update

# basic flask environment
RUN apk add --no-cache bash git nginx uwsgi uwsgi-python3 redis \
    && pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir flask

RUN apk --update add --no-cache zlib-dev python3-dev \
    libxml2-dev libxslt-dev libffi-dev gcc musl-dev libgcc curl \
    alpine-sdk openssl-dev python-dev \
    py3-pillow \
    #libxml2-dev libxslt-dev libffi-dev gcc musl-dev libgcc openssl-dev curl \
    zlib-dev freetype-dev lcms2-dev tiff-dev tk-dev tcl-dev \
    py3-psycopg2

ENV LIBRARY_PATH=/lib:/usr/lib
ENV APP_DIR=/app

# app dir
COPY . ${APP_DIR}
COPY requirements.txt ${APP_DIR}/requirements.txt
RUN pip3 install --no-cache-dir -r ${APP_DIR}/requirements.txt
RUN chown -R nginx:nginx ${APP_DIR} \
    && chmod 777 ${APP_DIR} -R \
    && chmod 777 /run/ -R \
    && chmod 777 /root/ -R
WORKDIR ${APP_DIR}

# expose web server port
# only http, for ssl use reverse proxy
EXPOSE 80

# copy config files into filesystem
COPY docker_includes/nginx.conf /etc/nginx/nginx.conf
COPY docker_includes/app.ini /app.ini
COPY docker_includes/entrypoint.sh /entrypoint.sh

# exectute start up script
ENTRYPOINT ["/entrypoint.sh"]
