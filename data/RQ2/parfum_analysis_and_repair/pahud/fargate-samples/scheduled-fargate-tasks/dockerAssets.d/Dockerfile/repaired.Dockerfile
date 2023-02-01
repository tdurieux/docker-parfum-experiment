FROM alpine:latest

RUN \
	mkdir -p /aws && \
	apk -Uuv add groff less python3 && \
	pip3 install --no-cache-dir awscli && \
	rm /var/cache/apk/*

WORKDIR /aws
ENTRYPOINT ["aws"]
