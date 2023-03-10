FROM arm64v8/alpine:3.14

ENV DKUID 1000
ENV DKGID 1000

RUN apk update && apk add --no-cache git openssh gcc musl-dev libffi-dev openssl-dev make bash py-pip pwgen bc npm shadow jq
RUN npm config set unsafe-perm true
RUN npm install -g qrcode-terminal && npm cache clean --force;
RUN npm install -g url-cli && npm cache clean --force;
RUN pip install --no-cache-dir awscli

# Work around with gid conflict between OSX and Alpine
# MacOSX: gid=20(staff)
# Alpine: gid=20(dialout)
RUN if [ "$(getent group ${DKGID}|cut -d":" -f1)" == "" ]; then addgroup -g ${DKGID} vlp; fi
RUN adduser -G `getent group ${DKGID}|cut -d":" -f1` -u ${DKUID} -s /bin/ash -h /vlp -D vlp
