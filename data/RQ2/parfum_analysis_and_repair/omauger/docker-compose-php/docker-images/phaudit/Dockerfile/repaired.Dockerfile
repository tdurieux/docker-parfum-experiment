FROM jolicode/phaudit

USER root

RUN wget https://phar.phpunit.de/phpunit-5.0.phar && \
    mv phpunit-5.0.phar /usr/local/bin/phpunit && \
    chmod +x /usr/local/bin/phpunit && \
    apt-get update && \
    apt-get install --no-install-recommends -y curl wget && \
    curl -fsSL https://get.docker.com/ | sh && \
    pip install --no-cache-dir docker-compose==1.7 && \
    pip install --no-cache-dir ipaddress && \
    pip install --no-cache-dir functools32 && \
    usermod -G docker travis && rm -rf /var/lib/apt/lists/*;

USER travis
