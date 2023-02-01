FROM ubuntu:20.04 AS build-stage

COPY libs/v8 v8

ARG DEBIAN_FRONTEND=noninteractive
RUN set -xe; \
	# Install dependencies
	apt-get update; \
	apt-get install --no-install-recommends -y \
		libxml2-dev build-essential\
		git xz-utils python2 python-is-python2 \
		ca-certificates curl pkg-config; \
	# Build V8 \
	/v8/build.sh; \
	# Delete unneeded V8 artifacts \
	find v8 -maxdepth 1 ! -name 'v8' -exec rm -rf {} \; ; \
	find v8/v8 -maxdepth 1 ! -name 'v8' ! -name 'include' ! -name 'out' -exec rm -rf {} \; ; \
	find v8/v8/out/x64.release/ -maxdepth 1  ! -name 'x64.release' ! -regex '.+\.so\|.+\.dat\|.+\.bin' -exec rm -rf {} \; ; \
	rm v8/v8/out/x64.release/libv8_for_testing.so; \
	apt-get remove -y \
		libxml2-dev build-essential\
		git xz-utils python2 python-is-python2 \
		ca-certificates curl pkg-config; \
	apt-get autoremove -y; \
	apt-get clean -y; \
	rm -rf /var/lib/apt/lists/*;

FROM alpine:3
COPY --from=build-stage /v8/v8 /v8/v8