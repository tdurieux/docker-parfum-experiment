# Dockerfile with a script to use terrascan's validating webhook
# configured in the kubernetes cluster, to scan a repo for violations
FROM alpine:3.14.6

#curl to send request to terrascan validating webhook
RUN apk add --no-cache curl

WORKDIR /home/terrascan

RUN mkdir bin

COPY scripts/argocd-terrascan-remote-scan.sh  bin/terrascan-remote-scan.sh

# create non root user