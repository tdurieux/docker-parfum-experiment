FROM harness/alpine:safe-alpine3.12-sec1338-apm

WORKDIR /code
RUN apk add --no-cache python3 py3-pip
RUN apk add --no-cache gcc musl-dev linux-headers wget openssl openssl-dev

COPY . .

RUN chmod +x ./install_redis.sh
RUN sh ./install_redis.sh

RUN pip3 install -r requirements.txt

RUN chmod +x run.sh
CMD [ "sh", "./run.sh" ]
