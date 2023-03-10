#Build stage 1
FROM maven:3.5.3-jdk-8 AS builder
MAINTAINER Hazem Ben Khalfallah <benkhalfallahhazem@gmail.com>

RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN mvn package -Dskip.unit.tests=true -Dskip.integration.tests=true

#Setup stage 2
FROM nginx:1.14.1-alpine

## Copy our default nginx config
COPY .nginx/default.conf /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From ‘builder’ stage copy over the artifacts in dist folder to default nginx public folder