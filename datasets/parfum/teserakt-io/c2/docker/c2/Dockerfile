###########################################################
#
# c2 stage
#
###########################################################
FROM alpine AS c2

ARG binary_path

# Redirect log file to stdout
RUN ln -s /dev/stdout /var/log/e4_c2.log

WORKDIR /opt/e4

# Default GRPC
EXPOSE 5555
# Default HTTp
EXPOSE 8888

VOLUME /opt/e4/configs

COPY $binary_path /opt/e4/bin/c2
COPY ./configs/ /opt/e4/configs
HEALTHCHECK --interval=1m --timeout=5s \
    # Have to disable the cert checks as Busybox wget doesn't have the GNU wget options to specify a custom ca cert.
    CMD [ "$(wget --no-check-certificate -qO- https://127.0.0.1:8888/e4/health-check)" == '{"Code":"0","Status":"OK"}' ] || exit 1

CMD ["/opt/e4/bin/c2"]

###########################################################
#
# c2cli stage
#
###########################################################
FROM alpine AS c2cli

ARG binary_path

WORKDIR /opt/e4

VOLUME /opt/c2/c2-cert.pem

ENV C2_API_ENDPOINT="localhost:5555"
ENV C2_API_CERT="/opt/c2/c2-cert.pem"

COPY $binary_path /opt/e4/bin/c2cli
COPY ./docker/c2/cli-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
