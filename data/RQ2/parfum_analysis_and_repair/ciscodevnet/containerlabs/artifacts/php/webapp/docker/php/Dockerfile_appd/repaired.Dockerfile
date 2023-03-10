FROM bitnami/php-fpm:7.1

RUN apt-get update && apt-get install --no-install-recommends -y curl procps && rm -rf /var/lib/apt/lists/*;

# Copy the php config file
COPY ./webapp/docker/php/php-fpm.conf /etc/php/7.1/fpm/pool.d/www.conf

COPY ./php-agent/ /opt/appdynamics/php-agent/

COPY ./start.sh /opt/appdynamics/start.sh

RUN chmod +x /opt/appdynamics/start.sh

# Copy the application code
COPY ./webapp /code


ENV APP_ENTRY_POINT "php-fpm -F --pid /opt/bitnami/php/tmp/php-fpm.pid -y /opt/bitnami/php/etc/php-fpm.conf"


ENTRYPOINT ["/bin/bash", "/opt/appdynamics/start.sh"]
