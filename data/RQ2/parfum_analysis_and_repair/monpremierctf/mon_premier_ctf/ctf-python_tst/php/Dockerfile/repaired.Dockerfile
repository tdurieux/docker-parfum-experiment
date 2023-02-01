FROM php:7-fpm

RUN apt-get update && apt-get install --no-install-recommends -y python && apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;

RUN useradd -d /home/yolo -s /bin/bash yolo --uid 3022
RUN echo "www-data ALL = (yolo) NOPASSWD: /usr/bin/python" >>/etc/sudoers
USER www-data