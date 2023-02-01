FROM alpine:3.10

ENV \
	LC_ALL=en_US.UTF-8 \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8

RUN \
	apk add --no-cache \
		build-base \
		python3 \
		python3-dev && \
	python3 -m ensurepip && \
	pip3 install --no-cache-dir \
		aiohttp==3.5.4

COPY ecs-credentials.py /

CMD ["python3", "/ecs-credentials.py"]
