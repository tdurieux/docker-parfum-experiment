FROM docker

RUN apk add --no-cache --update 'py-pip' && pip install --no-cache-dir "docker-compose"

WORKDIR /compose

CMD ["docker-compose", "version"]