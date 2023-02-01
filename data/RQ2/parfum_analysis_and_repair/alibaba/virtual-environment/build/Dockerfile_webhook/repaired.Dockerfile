FROM virtualenvironment/distroless-static:nonroot

WORKDIR /kt
COPY ./webhook-server /bin/
ENV PATH=/bin
USER nonroot:nonroot

ENTRYPOINT ["/bin/webhook-server"]