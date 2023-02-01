FROM --platform=$BUILDPLATFORM alpine:3.16 AS inngest
RUN apk add --no-cache ca-certificates tzdata && update-ca-certificates
COPY inngest /bin/inngest
CMD ["inngest"]