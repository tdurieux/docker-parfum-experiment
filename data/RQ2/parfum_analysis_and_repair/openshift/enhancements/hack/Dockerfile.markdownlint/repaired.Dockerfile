FROM fedora
WORKDIR /workdir
COPY install-markdownlint.sh /tmp
RUN dnf install -y git golang
RUN /tmp/install-markdownlint.sh
ENTRYPOINT /workdir/hack/markdownlint.sh