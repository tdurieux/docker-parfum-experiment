FROM golang:1.11.5

ADD iptables/ /go
# Kubernetes Jobs will be retried until they return status 0,
# so we need to output the status for processing but make sure
# that the container exits with 0
ENTRYPOINT cd /go && (go test -v -integration-tests; echo "status:$?")