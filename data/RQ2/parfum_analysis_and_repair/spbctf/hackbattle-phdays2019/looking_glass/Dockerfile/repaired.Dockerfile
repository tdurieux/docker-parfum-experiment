FROM httpd:alpine

WORKDIR /usr/src/app

COPY backend/requirements.txt .

RUN apk add --no-cache python3 supervisor

RUN pip3 install --no-cache-dir -r requirements.txt && \
    mkdir -p /var/log/supervisor

COPY backend/ .

COPY supervisord.conf /etc/supervisord.conf
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

