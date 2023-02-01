FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN rm -rf /etc/nginx/sites-enabled/default
EXPOSE 80
COPY nginx.conf /etc/nginx/sites-enabled/magritapp
RUN mkdir /var/www/static
COPY static /var/www/static
CMD ["nginx", "-g", "daemon off;"]
