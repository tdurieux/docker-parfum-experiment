##
# Copyright 2019 Jason H House
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##

FROM eclipse-temurin:11.0.14.1_1-jre

## Build image with sensible default environment values ##
ENV gapsVersion=*
ENV springProfile=no-ssl-no-login
ENV javaInitialHeapSize=150M
ENV baseUrl ""
#ENV baseUrl="/gaps"

EXPOSE 32400

## Create data directory ##
RUN mkdir -p /usr/data && chmod 777 /usr/data
COPY movieIds.json /usr/data

## Create application directory ##
RUN mkdir -p /usr/app/target && chmod 777 /usr/app

## Set working directory ##
WORKDIR /usr/app

## Set Docker Container Entrypoint Command ##