FROM ubuntu:14.04

MAINTAINER how2dock@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

RUN echo "foobar uses Docker" > /usr/share/nginx/html/index.html

CMD ["nginx","-g","daemon off;"]

EXPOSE 80
