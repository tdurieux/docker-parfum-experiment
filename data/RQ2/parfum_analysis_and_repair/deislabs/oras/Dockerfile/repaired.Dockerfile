FROM docker.io/library/golang:1.18.1-alpine as builder
ARG TARGETPLATFORM
RUN apk add --no-cache git make
ENV ORASPKG /oras
ADD . ${ORASPKG}
WORKDIR ${ORASPKG}
RUN make "build-$(echo $TARGETPLATFORM | tr / -)"
RUN mv ${ORASPKG}/bin/${TARGETPLATFORM}/oras /go/bin/oras

FROM docker.io/library/alpine:3.15.4
RUN apk --update --no-cache add ca-certificates
COPY --from=builder /go/bin/oras /bin/oras
RUN mkdir /workspace
WORKDIR /workspace
ENTRYPOINT  ["/bin/oras"]
