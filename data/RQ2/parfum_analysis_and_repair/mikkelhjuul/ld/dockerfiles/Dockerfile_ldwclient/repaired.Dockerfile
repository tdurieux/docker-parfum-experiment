FROM ld
COPY --from=mjuul/ld-client /ld-client /ld-client
ENTRYPOINT ["/ld-client"]