## Dockerfile for dev
## Differs from the release Dockerfile in that it allows re-compiling and re-starting
## the webserver from within the container

ARG GO_VERSION
FROM golang:$GO_VERSION

# we use runit so that we can stop the service without killing the container, and consequently
# play around with it
RUN apt-get update && apt-get install --no-install-recommends --yes runit && rm -rf /var/lib/apt/lists/*;
RUN mkdir /etc/service/webhook \
    && /bin/bash -c "echo -e '"'#!/bin/bash\nexec /go/src/sigs.k8s.io/windows-gmsa/admission-webhook/admission-webhook 2>&1\n'"' > /etc/service/webhook/run" \
    && chmod +x /etc/service/webhook/run
RUN ln -s /usr/bin/sv /etc/init.d/webhook

WORKDIR /go/src/sigs.k8s.io/windows-gmsa/admission-webhook

# copy go dependencies
COPY /vendor ./vendor

# build
COPY *.go ./
ARG VERSION
RUN go build -ldflags="-X main.version=${VERSION}"

# copy the rest
COPY . .

# let runit work its magic
CMD ["runsvdir", "/etc/service"]
