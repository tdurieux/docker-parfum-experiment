FROM alpine:latest

RUN apk add --no-cache python py-pip && \
	pip install --no-cache-dir awscli

COPY sync.sh .

RUN [ "chmod", "+x", "sync.sh" ]

ENTRYPOINT '/sync.sh'

CMD [ "" ]