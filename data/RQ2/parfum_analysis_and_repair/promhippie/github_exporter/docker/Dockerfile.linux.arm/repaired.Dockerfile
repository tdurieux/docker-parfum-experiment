FROM arm32v6/alpine:3.16@sha256:3c66139adbd2513f9fc56eff206513ffc8356b282bed31a4e74c7eb926b850aa AS build
RUN apk add --no-cache ca-certificates mailcap

FROM scratch

EXPOSE 9504
ENTRYPOINT ["/usr/bin/github_exporter"]
HEALTHCHECK CMD ["/usr/bin/github_exporter", "health"]

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/mime.types /etc/

COPY bin/github_exporter /usr/bin/github_exporter