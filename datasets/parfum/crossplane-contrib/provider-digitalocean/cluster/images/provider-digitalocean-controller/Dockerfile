FROM gcr.io/distroless/static@sha256:d2b0ec3141031720cf5eedef3493b8e129bc91935a43b50562fbe5429878d96b

ARG TARGETOS
ARG TARGETARCH

ADD bin/$TARGETOS\_$TARGETARCH/provider /usr/local/bin/crossplane-digitalocean-provider

EXPOSE 8080
USER 65532
ENTRYPOINT ["crossplane-digitalocean-provider"]
