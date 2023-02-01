FROM quay.io/fedora/fedora:37-x86_64 as builder
RUN yum install -y git golang make npm wget glibc && rm -rf /var/cache/yum
WORKDIR /opt/app-root/src/
COPY . .
RUN make build

FROM node:18-buster as frontend
COPY webui/ /watchman/
WORKDIR /watchman/
RUN npm install --legacy-peer-deps && npm cache clean --force;
RUN npm run build

FROM quay.io/fedora/fedora:37-x86_64
RUN yum install -y glibc && rm -rf /var/cache/yum

ARG VERSION=unknown
LABEL maintainer="Moov <support@moov.io>"
LABEL name="watchman"
LABEL version=$VERSION

COPY --from=builder /opt/app-root/src/bin/server /bin/server

COPY --from=frontend /watchman/build/ /watchman/
ENV WEB_ROOT=/watchman/

ENTRYPOINT ["/bin/server"]
