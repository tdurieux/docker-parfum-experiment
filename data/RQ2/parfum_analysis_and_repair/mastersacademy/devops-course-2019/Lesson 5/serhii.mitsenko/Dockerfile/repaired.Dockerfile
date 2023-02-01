FROM ubuntu:18.04
MAINTAINER Serhii Mitsenko

RUN apt update && apt install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
COPY index.html /var/www/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
