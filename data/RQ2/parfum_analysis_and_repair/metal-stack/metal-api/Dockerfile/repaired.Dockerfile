FROM metalstack/builder:latest as builder

FROM alpine:3.16
RUN apk -U --no-cache add ca-certificates
COPY --from=builder /work/bin/metal-api /metal-api
CMD ["/metal-api"]
