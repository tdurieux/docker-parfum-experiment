FROM debian:bullseye

# Build arguments
ARG VERSION
ENV NAME pganalyze-collector

ENV DEB_DIR /deb
RUN mkdir -p $DEB_DIR
RUN mkdir -p $DEB_DIR/systemd

RUN apt-get update -qq && apt-get install --no-install-recommends -y -q reprepro systemd-sysv && rm -rf /var/lib/apt/lists/*;

COPY sync_deb.sh /root
COPY deb.distributions /root
COPY ${NAME}_${VERSION}_amd64.deb $DEB_DIR/systemd/${NAME}_${VERSION}_amd64.deb
COPY ${NAME}_${VERSION}_arm64.deb $DEB_DIR/systemd/${NAME}_${VERSION}_arm64.deb

VOLUME ["/repo"]
