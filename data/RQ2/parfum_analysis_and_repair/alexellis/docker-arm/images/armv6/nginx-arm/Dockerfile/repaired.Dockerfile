FROM resin/rpi-raspbian

RUN apt-get -y update && \
    apt-get install --no-install-recommends -qy nginx && rm -rf /var/lib/apt/lists/*;

EXPOSE 80

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

