FROM php:7.4.25-fpm

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt install --no-install-recommends -y python3 xinetd && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


COPY ./app /app
COPY ./app/xinetd.conf /etc/xinetd.d/service
COPY ./flag /flag
RUN find /usr/local/lib/ -name "*.php" -type f -delete

RUN chmod +x /app/app.py /app/run.py
RUN chmod 777 /app/request
RUN useradd -m www
CMD ["/usr/sbin/xinetd","-dontfork"]