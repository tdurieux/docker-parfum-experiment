FROM debian:buster-slim
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /app/

RUN apt clean all
RUN apt update && apt -y --no-install-recommends install nginx php php-fpm php-mysql nano curl php-xml cron php-curl php-gd php-mbstring composer php-imagick git && rm -rf /var/lib/apt/lists/*;

COPY nginx.conf /etc/nginx/sites-available/
RUN ln -sf /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/default

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

