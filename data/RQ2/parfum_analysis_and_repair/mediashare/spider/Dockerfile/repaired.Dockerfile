FROM alpine:latest
RUN apk upgrade && apk update
RUN apk add --no-cache php php-xml php-curl php-ctype php-tokenizer php-pdo php-dom php-session
RUN apk add --no-cache composer git
WORKDIR /home
RUN git clone https://github.com/Mediashare/Spider spider
WORKDIR /home/spider
RUN composer install
EXPOSE 80 443