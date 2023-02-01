# Dockerfile
FROM ubuntu:trusty

RUN apt-get update && apt-get install --no-install-recommends -y \
	python-stdeb \
	fakeroot \
	python-all \
	git && rm -rf /var/lib/apt/lists/*;

COPY ./build-debs.sh /

