FROM ubuntu:21.04

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /souffle

# Install souffle build dependencies
RUN apt-get update && \
	apt-get -y install \
	bash-completion \
	sudo \
	autoconf \
	automake \
	bison \
	build-essential \
	clang \
	doxygen \
	flex \
	g++ \
	git \
	libffi-dev \
	libncurses5-dev \
	libtool \
	libsqlite3-dev \
	make \
	mcpp \
	python \
	sqlite \
	zlib1g-dev \
	cmake

# Copy everything into souffle directory
COPY . .

ENTRYPOINT [".github/images/entrypoint.sh"]
