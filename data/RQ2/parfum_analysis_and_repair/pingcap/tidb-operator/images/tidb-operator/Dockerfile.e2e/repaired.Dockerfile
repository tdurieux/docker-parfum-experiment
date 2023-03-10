FROM alpine:3.14

RUN apk add tzdata bash bind-tools --no-cache

ADD bin/tidb-scheduler /usr/local/bin/tidb-scheduler
ADD bin/tidb-discovery /usr/local/bin/tidb-discovery
ADD bin/tidb-controller-manager /usr/local/bin/tidb-controller-manager
ADD bin/tidb-admission-webhook /usr/local/bin/tidb-admission-webhook

ADD e2e-entrypoint.sh /e2e-entrypoint.sh