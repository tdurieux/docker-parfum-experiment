# Build the kdc-api-server in a separate container
FROM golang:1.11
WORKDIR /go/src/github.com/mesosphere/kdc-api-server
RUN go get -d -v golang.org/x/net/html gopkg.in/jcmturner/gokrb5.v7/keytab
COPY server/ /go/src/github.com/mesosphere/kdc-api-server
RUN go get github.com/dcos/client-go/dcos
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o api-server .

# Build a KDC container
FROM centos:centos7
WORKDIR /kdc
COPY docker/* /kdc/

ENV KRB5_CONFIG=/kdc/krb5.conf \
    KRB5_KDC_PROFILE=/kdc/kdc.conf \
    KDC_BIN=/usr/libexec/kdc \
    KADMIN_BIN=/usr/bin/heimdal-kadmin \
    KTUTIL_BIN=/usr/bin/heimdal-ktutil

RUN yum -y install epel-release && \
    yum install -y heimdal-server heimdal-workstation supervisor && \
    yum clean all && \
    mkdir -p /var/heimdal && \
    kstash --random-key && \
    ${KADMIN_BIN} -l init --realm-max-ticket-life=unlimited --realm-max-renewable-life=unlimited LOCAL && rm -rf /var/cache/yum

COPY --from=0 /go/src/github.com/mesosphere/kdc-api-server/api-server /kdc

CMD /usr/bin/supervisord -c /kdc/supervisord.conf
