FROM python:3.5-alpine3.10 AS build

RUN mkdir /OpenUBA/
COPY ./core ./OpenUBA
COPY ./Makefile ./OpenUBA/Makefile
WORKDIR /OpenUBA/