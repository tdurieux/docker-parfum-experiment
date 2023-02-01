# Dockerfile
FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y \
	python-stdeb \
	fakeroot \
	python-all \
        dh-python \
	git && rm -rf /var/lib/apt/lists/*;

COPY ./build-debs.sh /

