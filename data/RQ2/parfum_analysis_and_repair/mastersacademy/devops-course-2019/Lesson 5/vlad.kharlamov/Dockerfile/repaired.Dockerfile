FROM ubuntu:18.04
LABEL maintainer="vlad@kharlamov.com.ua"
RUN apt update && apt install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
COPY index.html /var/www/html/
EXPOSE 80/tcp
CMD  ["nginx","-g","daemon off;"]
