ARG BUILD_FROM
FROM ${BUILD_FROM}
RUN apt-get update && apt-get install --no-install-recommends -qq -y socat curl && rm -rf /var/lib/apt/lists/*;
COPY rootfs /
CMD ["/usr/bin/run.sh"]
