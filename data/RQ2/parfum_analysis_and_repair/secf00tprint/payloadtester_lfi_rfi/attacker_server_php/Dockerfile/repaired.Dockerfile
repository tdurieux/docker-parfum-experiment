FROM php:7.3-apache

LABEL maintainer="secf00tprint@gmail.com"

COPY start.sh /
RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
CMD ["/start.sh"]
