FROM ubuntu:18.04
LABEL maintainer="james@example.com"
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN echo 'Hi, I am in your container' \
    >/var/www/html/index.html
EXPOSE 80
