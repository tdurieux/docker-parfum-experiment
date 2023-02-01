FROM nginx:1.13.5

ENV SWAGGER_UI_VERSION 3.4.5
ENV URL **None**

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl \
    && curl -f -L https://github.com/swagger-api/swagger-ui/archive/v${SWAGGER_UI_VERSION}.tar.gz | tar -zxv -C /tmp \
    && cp -R /tmp/swagger-ui-${SWAGGER_UI_VERSION}/dist/* /usr/share/nginx/html \
    && rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*;

RUN rm /etc/nginx/conf.d/default.conf
ADD /nginx.conf /etc/nginx/conf.d

ADD start.sh /start.sh

CMD ["/start.sh"]
