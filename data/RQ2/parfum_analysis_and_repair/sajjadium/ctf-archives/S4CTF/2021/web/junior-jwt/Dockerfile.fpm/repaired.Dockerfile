FROM php:7-fpm

ADD ./html /code
ADD ./flag.txt /
ADD ./jwtRS256.key /