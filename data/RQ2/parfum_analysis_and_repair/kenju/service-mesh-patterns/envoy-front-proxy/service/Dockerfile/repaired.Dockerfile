FROM envoyproxy/envoy-alpine-dev:latest

RUN apk update && apk add --no-cache python3 bash curl
RUN pip3 install --no-cache-dir -q Flask==0.11.1 requests==2.18.4
RUN mkdir /code
COPY ./service.py /code
COPY ./start_service.sh /usr/local/bin/start_service.sh
COPY ./service-envoy.yaml /etc/service-envoy.yaml
RUN chmod u+x /usr/local/bin/start_service.sh
ENTRYPOINT /usr/local/bin/start_service.sh
