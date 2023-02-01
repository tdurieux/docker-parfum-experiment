FROM debian:stretch-slim
LABEL maintainer="Piotr Mazurkiewicz <piotr.mazurkiewicz@wearco.pl>"

RUN apt-get update \
		&& apt-get install -y --no-install-recommends \
			curl \
			ca-certificates \
		&& apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /
COPY build/vci-provisioner /

ENTRYPOINT ["/entrypoint.sh"]

CMD [""]
