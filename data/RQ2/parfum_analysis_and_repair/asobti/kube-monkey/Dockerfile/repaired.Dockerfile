########################
### Builder          ###
########################
FROM golang:1.18 as builder
RUN mkdir -p /kube-monkey
COPY ./ /kube-monkey/
WORKDIR /kube-monkey
RUN make build

########################
### Final            ###
########################