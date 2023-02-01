FROM registry.fedoraproject.org/fedora:36
COPY test-packages .
RUN dnf -y install $(cat test-packages) && touch /.in-container
RUN useradd weldr
VOLUME /lorax-ro
VOLUME /test-results
WORKDIR /lorax-ro