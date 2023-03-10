FROM alpine:3.15
RUN apk add --no-cache --update \
    bash \
    bc \
    build-base \
    bison \
    flex \
    curl \
    elfutils-dev \
    linux-headers \
	gmp-dev \
	mpc1-dev \
	mpfr-dev \
	python3 \
    make \
    openssl-dev

WORKDIR /

COPY /init/fetch-linux-headers.sh /

ENTRYPOINT [ "/fetch-linux-headers.sh" ]
