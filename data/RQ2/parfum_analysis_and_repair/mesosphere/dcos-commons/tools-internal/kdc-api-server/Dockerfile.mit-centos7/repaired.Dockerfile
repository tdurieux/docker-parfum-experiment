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
    KDC_BIN=/usr/sbin/krb5kdc \
    KADMIN_BIN=/sbin/kadmin.local

RUN yum -y install epel-release && \
    yum install -y krb5-server supervisor && \
    yum clean all && \
    echo -e "\n\n" | kdb5_util create -r LOCAL -s && rm -rf /var/cache/yum

COPY --from=0 /go/src/github.com/mesosphere/kdc-api-server/api-server /kdc

CMD /usr/bin/supervisord -c /kdc/supervisord.conf
