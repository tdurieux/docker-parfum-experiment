FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY bin/adapter /bin/adapter
CMD ["/bin/adapter"]