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
	pip3 install --no-cache-dir \
		coverage==4.5.3 && \
	wget -O mc https://dl.min.io/client/mc/release/linux-amd64/archive/mc.RELEASE.2019-12-24T23-41-36Z && \
	chmod +x mc

COPY LICENSE README.md mobius3.py setup.py test.py test_with_coverage.sh .coveragerc /
