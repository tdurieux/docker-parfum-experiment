FROM debian

RUN apt-get update && apt-get install --no-install-recommends -yq openssl && rm -rf /var/lib/apt/lists/*;

ADD make_certs.sh /


WORKDIR /data
VOLUME ["/data"]
CMD /make_certs.sh
