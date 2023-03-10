FROM debian:buster-slim as build

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		ca-certificates \
		make \
		gcc \
		git \
		libevent-dev \
		libjpeg62-turbo-dev \
		libbsd-dev \
		libgpiod-dev \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /build/ustreamer/
COPY . .
RUN make -j5 WITH_GPIO=1

FROM debian:buster-slim as run

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		ca-certificates \
		libevent-2.1 \
		libevent-pthreads-2.1-6 \
		libjpeg62-turbo \
		libbsd0 \
		libgpiod2 \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /ustreamer
COPY --from=build /build/ustreamer/ustreamer .

#ENV LD_LIBRARY_PATH=/opt/vc/lib
EXPOSE 8080
ENTRYPOINT ["./ustreamer", "--host=0.0.0.0"]

# vim: syntax=dockerfile
