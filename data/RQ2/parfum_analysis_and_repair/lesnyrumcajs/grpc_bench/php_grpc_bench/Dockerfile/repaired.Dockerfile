FROM php:zts-buster

WORKDIR /app

RUN apt update && apt install --no-install-recommends -y protobuf-compiler wget git && rm -rf /var/lib/apt/lists/*;
RUN pecl install protobuf

RUN wget https://github.com/spiral/php-grpc/releases/download/v1.2.1/protoc-gen-php-grpc-1.2.1-linux-amd64.tar.gz
RUN wget https://github.com/spiral/php-grpc/releases/download/v1.2.1/rr-grpc-1.2.1-linux-amd64.tar.gz
RUN tar -xvf protoc-gen-php-grpc-1.2.1-linux-amd64.tar.gz && cp protoc-gen-php-grpc-1.2.1-linux-amd64/protoc-gen-php-grpc /usr/bin/ && rm protoc-gen-php-grpc-1.2.1-linux-amd64.tar.gz
RUN tar -xvf rr-grpc-1.2.1-linux-amd64.tar.gz && cp rr-grpc-1.2.1-linux-amd64/rr-grpc /usr/bin/ && rm rr-grpc-1.2.1-linux-amd64.tar.gz

COPY proto /app/proto
COPY php_grpc_bench/composer.json /app/composer.json

RUN mkdir src && protoc --php_out=src --php-grpc_out=src --proto_path=/app/proto/helloworld helloworld.proto
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --quiet
RUN ./composer.phar install

COPY php_grpc_bench /app

ENTRYPOINT [ "rr-grpc", "serve" ]
