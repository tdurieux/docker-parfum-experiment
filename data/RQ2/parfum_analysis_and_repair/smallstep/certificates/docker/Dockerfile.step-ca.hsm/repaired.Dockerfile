FROM golang:alpine AS builder

WORKDIR /src
COPY . .

RUN apk add --no-cache curl git make
RUN apk add --no-cache gcc musl-dev pkgconf pcsc-lite-dev
RUN make V=1 GOFLAGS="" build


FROM smallstep/step-cli:latest

COPY --from=builder /src/bin/step-ca /usr/local/bin/step-ca
COPY --from=builder /src/bin/step-awskms-init /usr/local/bin/step-awskms-init
COPY --from=builder /src/bin/step-cloudkms-init /usr/local/bin/step-cloudkms-init
COPY --from=builder /src/bin/step-pkcs11-init /usr/local/bin/step-pkcs11-init
COPY --from=builder /src/bin/step-yubikey-init /usr/local/bin/step-yubikey-init

USER root
RUN apk add --no-cache libcap && setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/step-ca
RUN apk add --no-cache pcsc-lite pcsc-lite-libs
USER step

ENV CONFIGPATH="/home/step/config/ca.json"
ENV PWDPATH="/home/step/secrets/password"

VOLUME ["/home/step"]
STOPSIGNAL SIGTERM
HEALTHCHECK CMD step ca health 2>/dev/null | grep "^ok" >/dev/null

COPY docker/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD exec /usr/local/bin/step-ca --password-file $PWDPATH $CONFIGPATH