FROM cloudfoundry/cf-deployment-concourse-tasks
MAINTAINER https://github.com/cloudfoundry/bosh-bootloader

# Create directory for GOPATH
RUN mkdir -p /go/bin

ENV GOPATH /go

# add go and GOPATH/bin to PATH
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN \
      apt-get update && \
      apt-get -qqy --no-install-recommends install --fix-missing \
            silversearcher-ag \
            tree \
            apt-transport-https \
            openssl \
            unzip \
      && \
      apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN go get -u github.com/jteeuwen/go-bindata/...

# Install gcloud
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk-trusty main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  apt-get update && \
  apt-get -qqy --no-install-recommends install google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

# add bbl from latest commit
ADD bbl /usr/local/bin/

ADD bosh-bootloader /go/src/github.com/cloudfoundry/bosh-bootloader

RUN cp -r /go/src/github.com/cloudfoundry/bosh-bootloader /var/repos
