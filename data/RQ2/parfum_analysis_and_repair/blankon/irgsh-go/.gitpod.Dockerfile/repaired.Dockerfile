FROM debian:buster-slim
RUN apt update && apt install --no-install-recommends -y gpg pbuilder debootstrap devscripts python-apt reprepro make && \
  curl -f -O https://storage.googleapis.com/golang/go1.13.14.linux-amd64.tar.gz && \
  tar -xf go1.13.14.linux-amd64.tar.gz && \
  mv go /usr/local && \
  rm -rf go1.13.14.linux-amd64.tar.gz && rm -rf /var/lib/apt/lists/*;
ENV PATH="${PATH}:/usr/local/go/bin"
