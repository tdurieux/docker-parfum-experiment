FROM php:7.4

RUN apt-get update && \
    apt-get install --no-install-recommends -y git unzip zip && rm -rf /var/lib/apt/lists/*;

RUN pecl install channel://pecl.php.net/runkit7-4.0.0a3
RUN pecl install uopz

ENV PATH=/root/bin:$PATH

CMD "/bin/bash"
