FROM gcr.io/distroless/cc


COPY --chown=4001:4001 ./polymesh /
USER 4001:4001

ENTRYPOINT ["/polymesh"]
CMD [ "-d", "/var/lib/polymesh" ]