FROM envoyproxy/envoy-alpine-dev:latest

RUN apk update && apk add --no-cache py3-pip bash curl
RUN mkdir /code
ADD ./start_service.sh /usr/local/bin/start_service.sh
COPY . ./code

RUN pip3 install --no-cache-dir -q Flask==0.11.1

RUN chmod u+x /usr/local/bin/start_service.sh
ENTRYPOINT ["/bin/sh", "/usr/local/bin/start_service.sh"]
