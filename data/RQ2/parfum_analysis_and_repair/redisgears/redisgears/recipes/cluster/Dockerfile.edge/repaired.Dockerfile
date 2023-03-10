FROM redislabs/redisgears:edge

WORKDIR /cluster
COPY create-cluster .
COPY docker-config.sh .
COPY docker-entrypoint.sh /usr/local/bin
EXPOSE 30001-30006
CMD []