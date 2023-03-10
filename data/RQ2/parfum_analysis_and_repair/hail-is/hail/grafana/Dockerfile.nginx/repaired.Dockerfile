FROM {{ hail_ubuntu_image.image }}

RUN hail-apt-get-install nginx

RUN rm -f /etc/nginx/sites-enabled/default && \
    rm -f /etc/nginx/nginx.conf
ADD nginx.conf.out /etc/nginx/nginx.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["nginx", "-g", "daemon off;"]