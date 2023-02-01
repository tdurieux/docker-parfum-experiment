FROM livegrep/base
RUN apt-get -y --no-install-recommends install nginx && rm -rf /var/lib/apt/lists/*;
ADD nginx.conf /livegrep/nginx.conf

CMD nginx -c /livegrep/nginx.conf
