FROM debian:stretch-slim

RUN set -x \
	&& apt update \
	&& apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

CMD ["bash"]
