FROM debian:buster

RUN set -eu; \
	apt-get update -qy ; \
	apt-get install --no-install-recommends -qy \
        devscripts \
        ; rm -rf /var/lib/apt/lists/*; \
	apt-get clean ; \
    :
