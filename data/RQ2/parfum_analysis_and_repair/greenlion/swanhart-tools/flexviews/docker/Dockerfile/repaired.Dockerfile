FROM mysql:5.6

ENV DEBIAN_FRONTEND=noninteractive

ADD . flexviews

RUN apt-get update && apt-get install --no-install-recommends -y \
    php \
    php-mysqli \
    php-pear && rm -rf /var/lib/apt/lists/*;

WORKDIR flexviews/consumer

CMD php setup_flexcdc.php --force && php run_consumer.php
