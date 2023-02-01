FROM circleci/php:7.0-fpm-node-browsers

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y pv mysql-client sshpass && rm -rf /var/lib/apt/lists/*;
RUN sudo docker-php-ext-install mysqli pdo pdo_mysql
