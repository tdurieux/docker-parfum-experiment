FROM istsos/istsos:latest

RUN apk update && \  
    set -ex && \
    apk add --no-cache g++

RUN pip3 install --no-cache-dir pandas==1.3.3

EXPOSE 80
