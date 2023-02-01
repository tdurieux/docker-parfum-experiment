ARG BASE_IMAGE=ubuntu:16.04

FROM golang:1.10.3 as builder
WORKDIR /go/src/github.com/ot4i/ace-docker/
ARG IMAGE_REVISION="Not specified"
ARG IMAGE_SOURCE="Not specified"
COPY cmd/ ./cmd
COPY internal/ ./internal
COPY vendor/ ./vendor
RUN go build -ldflags "-X \"main.ImageCreated=$(date --iso-8601=seconds)\" -X \"main.ImageRevision=$IMAGE_REVISION\" -X \"main.ImageSource=$IMAGE_SOURCE\"" ./cmd/runaceserver/
RUN go build ./cmd/chkaceready/
RUN go build ./cmd/chkacehealthy/
# Run all unit tests
RUN go test -v ./cmd/runaceserver/
RUN go test -v ./internal/...
RUN go vet ./cmd/... ./internal/...

FROM ubuntu:16.04 as aceinstall
ARG ACE_INSTALL=ace-11.0.0.2.tar.gz
WORKDIR /opt/ibm
COPY deps/$ACE_INSTALL .
RUN mkdir ace-11
RUN tar xzf $ACE_INSTALL --absolute-names --exclude ace-11.\*/tools --strip-components 1 --directory /opt/ibm/ace-11

FROM $BASE_IMAGE

WORKDIR /opt/ibm

# Install ACE V11
RUN apt update && apt -y install --no-install-recommends sudo openssl \
  && rm -rf /var/lib/apt/lists/*

ADD https://storage.googleapis.com/kubernetes-release/release/v1.11.2/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl && \
    /usr/local/bin/kubectl version --client

COPY --from=aceinstall /opt/ibm/ace-11 /opt/ibm/ace-11

RUN /opt/ibm/ace-11/ace make registry global accept license silently

# Copy in PID1 process
COPY --from=builder /go/src/github.com/ot4i/ace-docker/runaceserver /usr/local/bin/
COPY --from=builder /go/src/github.com/ot4i/ace-docker/chkace* /usr/local/bin/

# Configure the system and Increase security
RUN echo "ACE_11:" > /etc/debian_chroot \
  && sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password \
  && sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t1/' /etc/login.defs \
  && sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/' /etc/login.defs

# Copy in script files
COPY *.sh /usr/local/bin/

# Create a user to run as, create the ace workdir, and chmod script files
RUN useradd --create-home --home-dir /home/aceuser -G mqbrkrs,sudo aceuser \
  && sed -e 's/^%sudo	.*/%sudo	ALL=NOPASSWD:ALL/g' -i /etc/sudoers \
  && su - aceuser -c '. /opt/ibm/ace-11/server/bin/mqsiprofile && mqsicreateworkdir /home/aceuser/ace-server' \
  && chmod 755 /usr/local/bin/*

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/usr/local/bin/ace_env.sh

# Expose ports.  7600, 7800, 7843 for ACE; 9483 for ACE metrics
EXPOSE 7600 7800 7843 9483

USER aceuser

WORKDIR /home/aceuser
RUN mkdir /home/aceuser/initial-config && chown aceuser:aceuser /home/aceuser/initial-config

ENV LOG_FORMAT=basic

# Set entrypoint to run management script
ENTRYPOINT ["runaceserver"]
