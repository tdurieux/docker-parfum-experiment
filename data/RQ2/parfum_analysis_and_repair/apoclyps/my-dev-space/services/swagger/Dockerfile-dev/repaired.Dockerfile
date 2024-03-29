FROM nginx:1.15.6-alpine

ENV SWAGGER_UI_VERSION 3.4.5
ENV URL **None**

RUN wget -qO- https://github.com/swagger-api/swagger-ui/archive/v${SWAGGER_UI_VERSION}.tar.gz | tar -zxv -C /tmp \
    && cp -R /tmp/swagger-ui-${SWAGGER_UI_VERSION}/dist/* /usr/share/nginx/html \
    && rm -rf /tmp/*

RUN rm /etc/nginx/conf.d/default.conf
ADD /nginx.conf /etc/nginx/conf.d

ADD start.sh /start.sh

ENTRYPOINT ["sh","/start.sh"]