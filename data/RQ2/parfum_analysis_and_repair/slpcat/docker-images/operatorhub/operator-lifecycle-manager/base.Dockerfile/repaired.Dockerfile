FROM golang:1.10 as builder
WORKDIR /go/src/github.com/operator-framework/operator-lifecycle-manager

# SSH key to fetch operator-client dependency. should be base64 encoded
# "--build-arg sshkey=`cat ~/.ssh/robot_rsa | base64 -w0`"
ARG sshkey
RUN mkdir -p ~/.ssh
RUN apt-get install -y --no-install-recommends make git openssh-client gcc g++ && rm -rf /var/lib/apt/lists/*;

COPY Gopkg.toml Gopkg.lock Makefile ./

RUN echo $sshkey | base64 -d > ~/.ssh/id_rsa  \
    && chmod 400 ~/.ssh/id_rsa \
    && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts \
    && make vendor
