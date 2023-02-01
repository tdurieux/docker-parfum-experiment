FROM alpine:3.9
RUN apk add --no-cache libgcc
COPY bin/?olaris /usr/local/bin/
CMD ["polaris"]
