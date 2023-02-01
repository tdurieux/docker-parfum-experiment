FROM nginx:latest

RUN apt-get update \
    && apt-get install --no-install-recommends -y logrotate && rm -rf /var/lib/apt/lists/*;

#Logrotate
COPY app/logrotate.d/logrotate.conf /etc/logrotate.conf
RUN chmod 644 /etc/logrotate.conf

#Nginx
COPY app/nginx /etc/nginx
COPY app/start.sh /opt/nginx/start.sh
RUN chmod +x /opt/nginx/start.sh

CMD /opt/nginx/start.sh
