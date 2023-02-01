FROM python:3.6-alpine

RUN echo -e "http://mirrors.aliyun.com/alpine/v3.9/main\nhttp://mirrors.aliyun.com/alpine/v3.9/community" > /etc/apk/repositories
RUN apk update && apk add --no-cache  nginx mariadb nodejs-npm git 
RUN apk add --no-cache --virtual .build-deps  openssl-dev gcc musl-dev python3-dev libffi-dev openssl-dev make
RUN git clone https://github.com/openspug/spug.git --depth=1 /spug && cd /spug && git pull
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/  && pip install --upgrade pip && pip install --no-cache-dir -r /spug/spug_api/requirements.txt \
    && pip install --no-cache-dir gunicorn \
    && apk del .build-deps
RUN cd /spug/spug_web/ && npm i && npm run build \
    && mv /spug/spug_web/dist /var/www/

ADD default.conf /etc/nginx/conf.d/default.conf
ADD entrypoint.sh /entrypoint.sh
ADD scripts /scripts

ENTRYPOINT ["sh", "/entrypoint.sh"]
