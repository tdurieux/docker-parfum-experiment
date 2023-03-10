# TODO(jlewi): How can we make it work with golang:1.8.2-alpine
FROM golang:1.8.2

RUN mkdir -p /opt/mlkube
RUN mkdir -p /opt/mlkube/test
COPY mx_operator /opt/mlkube
COPY e2e /opt/mlkube/test
RUN chmod a+x /opt/mlkube/mx_operator
RUN chmod a+x /opt/mlkube/test/e2e

# TODO(jlewi): Reduce log level.