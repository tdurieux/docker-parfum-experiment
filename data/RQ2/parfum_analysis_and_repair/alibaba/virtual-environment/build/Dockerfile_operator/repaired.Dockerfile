FROM virtualenvironment/distroless-static:nonroot

WORKDIR /kt
COPY ./virtual-env-operator /bin/
COPY ./inspector /bin/
ENV PATH=/bin
USER nonroot:nonroot

ENTRYPOINT ["/bin/virtual-env-operator"]