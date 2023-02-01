FROM golang:alpine AS builder

WORKDIR /src
COPY . .

RUN apk add --no-cache curl git make
RUN make V=1 bin/step-ca bin/step-awskms-init bin/step-cloudkms-init


FROM smallstep/step-cli:latest

COPY --from=builder /src/bin/step-ca /usr/local/bin/step-ca
COPY --from=builder /src/bin/step-awskms-init /usr/local/bin/step-awskms-init
COPY --from=builder /src/bin/step-cloudkms-init /usr/local/bin/step-cloudkms-init

USER root
RUN apk add --no-cache libcap && setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/step-ca
USER step

ENV CONFIGPATH="/home/step/config/ca.json"
ENV PWDPATH="/home/step/secrets/password"

VOLUME ["/home/step"]
STOPSIGNAL SIGTERM
HEALTHCHECK CMD step ca health 2>/dev/null | grep "^ok" >/dev/null

COPY docker/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD exec /usr/local/bin/step-ca --password-file $PWDPATH $CONFIGPATH