FROM fedora
WORKDIR /workdir
COPY install-markdownlint.sh /tmp
RUN /tmp/install-markdownlint.sh
ENTRYPOINT /workdir/hack/markdownlint.sh