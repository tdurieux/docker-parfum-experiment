FROM alpine:3.12

RUN apk add --no-cache python2 python2-dev gcc build-base musl-dev libffi-dev openssl-dev && \
	python -m ensurepip && \
	pip install --no-cache-dir --upgrade pip && \
	pip install --no-cache-dir --no-python-version-warning autobahntestsuite

VOLUME /config
VOLUME /report

ENV modeEnv=${mode}
ENV specEnv=${spec}

ENTRYPOINT ["/usr/bin/wstest","--mode", "${modeEnv}","--spec","${specEnv}"]
