FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

RUN rm -v /etc/nginx/nginx.conf
ADD docker/nginx.conf /etc/nginx/

COPY build/ /var/www/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
