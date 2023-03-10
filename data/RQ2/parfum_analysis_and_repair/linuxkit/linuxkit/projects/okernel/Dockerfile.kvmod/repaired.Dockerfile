ARG IMAGE
FROM ${IMAGE} AS kernel

FROM scratch
ENTRYPOINT []
WORKDIR /
COPY --from=kernel kernel_vuln.ko .
CMD ["insmod", "/kernel_vuln.ko"]