FROM scratch
COPY vangen vangen
ENTRYPOINT ["/vangen"]