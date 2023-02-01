FROM nginx

ADD nginx.tmpl /etc/nginx/
ADD run.sh /

RUN chmod +x /run.sh

RUN apt-get update; apt-get install --no-install-recommends -y \
    openssl && rm -rf /var/lib/apt/lists/*;

CMD /run.sh
