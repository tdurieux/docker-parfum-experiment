FROM pensiero/apache-php-mysql:latest

RUN apt update -q && apt install --no-install-recommends -yqq --force-yes \
    mysql-server && rm -rf /var/lib/apt/lists/*;

# Start mysql
RUN /etc/init.d/mysql 'start'

WORKDIR /var/www/public
COPY . ./
