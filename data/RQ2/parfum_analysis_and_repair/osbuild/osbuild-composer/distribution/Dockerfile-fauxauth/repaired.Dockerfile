FROM registry.access.redhat.com/ubi8/go-toolset:latest AS builder
COPY . .
ENV GOFLAGS=-mod=vendor
RUN go install ./cmd/osbuild-mock-openid-provider/

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
RUN microdnf install python3
RUN mkdir -p "/usr/libexec/osbuild-composer"
RUN mkdir -p "/etc/osbuild-composer/"

COPY --from=builder /opt/app-root/src/go/bin/osbuild-mock-openid-provider /usr/libexec/osbuild-composer/
COPY ./containers/fauxauth/fauxauth.py /opt/fauxauth.py

EXPOSE 8080 8080
ENTRYPOINT "/opt/fauxauth.py"