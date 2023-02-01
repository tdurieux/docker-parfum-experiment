# monk OS build tools

FROM brett/gcc-cross-x86_64-elf
MAINTAINER Brett Vickers

RUN set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y git nasm genisoimage \
	&& mkdir -p /code && rm -rf /var/lib/apt/lists/*;

VOLUME /code

CMD ["/bin/bash"]
