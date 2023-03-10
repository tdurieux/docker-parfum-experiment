FROM littr-builder AS builder

ARG ENV
ARG HOSTNAME

ENV GO111MODULE=on
ENV ENV=${ENV:-prod}

WORKDIR /go/src/
ADD ./ ./app/

WORKDIR /go/src/app
RUN make all && \
    docker/gen-certs.sh app

FROM gcr.io/distroless/static

ARG HOSTNAME
ARG PORT

ENV ENV ${ENV:-prod}
ENV LISTEN_HOSTNAME ${HOSTNAME:-brutalinks}
ENV LISTEN_PORT ${PORT:-3003}
ENV KEY_PATH=/etc/ssl/certs/app.key
ENV CERT_PATH=/etc/ssl/certs/app.crt
ENV HTTPS=true

EXPOSE ${PORT:-3003}

VOLUME /.env
VOLUME /storage

COPY --from=builder /go/src/app/*.key /go/src/app/*.crt /go/src/app/*.pem /etc/ssl/certs/
COPY --from=builder /go/src/app/bin/brutalinks /bin/brutalinks

CMD ["/bin/brutalinks"]