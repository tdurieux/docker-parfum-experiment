FROM alpine
RUN adduser -D buildtest
USER buildtest
WORKDIR /workdir/created/deep/below