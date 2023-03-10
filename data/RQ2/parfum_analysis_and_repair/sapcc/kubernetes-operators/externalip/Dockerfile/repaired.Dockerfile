FROM alpine:3.5
MAINTAINER Fabian Ruff <fabian.ruff@sap.com> 
LABEL source_repository="https://github.com/sapcc/kubernetes-operators"

RUN apk add --no-cache iptables

ADD bin/linux/externalip externalip
RUN /externalip --version

ENTRYPOINT ["/externalip"]