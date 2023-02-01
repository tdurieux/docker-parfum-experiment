from docker

RUN apk add --no-cache make
RUN apk add --no-cache bash
RUN apk add --no-cache python3
RUN apk --update --no-cache add 'py-pip' && pip install --no-cache-dir 'docker-compose'

ADD . /app

WORKDIR /app
