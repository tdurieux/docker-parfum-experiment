FROM alpine:3.12.0

ARG kopano_kustomerd_version=latest

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

WORKDIR /var/lib/kustomerd-docker

RUN apk add --no-cache \
		ca-certificates \
		curl \
        su-exec \
	&& curl -f -sSL https://download.kopano.io/community/kustomer%3A/kopano-kustomer-${kopano_kustomerd_version}.tar.gz | \
	tar -C /var/lib/kustomerd-docker --strip 1 -vxzf - && \
	mv kustomerd /usr/local/bin/

RUN mkdir /run/kopano-kustomerd && chown nobody /run/kopano-kustomerd

VOLUME /etc/kopano/licenses
VOLUME /run/kopano-kustomerd

ENTRYPOINT [ "kustomerd" ]
CMD [ "serve" ]
