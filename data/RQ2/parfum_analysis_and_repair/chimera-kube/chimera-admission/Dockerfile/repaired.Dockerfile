#####################
# Build environment #
#####################

FROM golang:1.15-buster

WORKDIR /code/chimera-admission
COPY . .
RUN go build

#########################
# Final container image #
#########################

FROM debian:buster-slim
LABEL org.opencontainers.image.source https://github.com/chimera-kube/chimera-admission

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY --from=0 /code/chimera-admission/chimera-admission /usr/bin/chimera-admission
ENTRYPOINT ["/usr/bin/chimera-admission"]
EXPOSE 8443

RUN adduser --uid 2000 chimera
USER chimera
