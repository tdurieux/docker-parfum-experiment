FROM debian:jessie

LABEL maintainer "https://github.com/blacktop"

LABEL malice.plugin.repository = "https://github.com/malice-plugins/blacktop.git"
LABEL malice.plugin.category="av"
LABEL malice.plugin.mime="*"
LABEL malice.plugin.docker.engine="*"

ARG BDKEY
ENV BDVERSION 7.7-1

ENV BDURLPART BitDefender_Antivirus_Scanner_for_Unices/Unix/Current/EN_FR_BR_RO/Linux/
ENV BDURL https://download.bitdefender.com/SMB/Workstation_Security_and_Management/${BDURLPART}

COPY BitDefender-Antivirus-Scanner-7.7-1-linux-amd64.deb.run /tmp
RUN buildDeps='ca-certificates wget build-essential' \
  && apt-get update -qq \
  && apt-get install --no-install-recommends -yq $buildDeps psmisc \
  && set -x \
  && echo "===> Install Bitdefender..." \
  && cd /tmp \
  && chmod 755 /tmp/BitDefender-Antivirus-Scanner-${BDVERSION}-linux-amd64.deb.run \
  && sh /tmp/BitDefender-Antivirus-Scanner-${BDVERSION}-linux-amd64.deb.run --check \
  && echo "===> Making installer noninteractive..." \
  && sed -i 's/^more LICENSE$/cat  LICENSE/' BitDefender-Antivirus-Scanner-${BDVERSION}-linux-amd64.deb.run \
  && sed -i 's/^CRCsum=.*$/CRCsum="0000000000"/' BitDefender-Antivirus-Scanner-${BDVERSION}-linux-amd64.deb.run \
  && sed -i 's/^MD5=.*$/MD5="00000000000000000000000000000000"/' BitDefender-Antivirus-Scanner-${BDVERSION}-linux-amd64.deb.run \
  && (echo 'accept'; echo 'n') | sh /tmp/BitDefender-Antivirus-Scanner-${BDVERSION}-linux-amd64.deb.run \
  && echo "===> Update License..." \
  && oldkey='^Key =.*$' \
  && newkey='Key = "${BDKEY}"' \
  && sed -i "s|$oldkey|$newkey|g" /opt/BitDefender-scanner/etc/bdscan.conf \
  && cat /opt/BitDefender-scanner/etc/bdscan.conf \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /go /usr/local/go

# ENV GO_VERSION 1.8.3
#
# COPY . /go/src/github.com/malice-plugins/bitdefender
# RUN buildDeps='ca-certificates \
#                build-essential \
#                gdebi-core \
#                libssl-dev \
#                mercurial \
#                git-core \
#                wget' \
#   && apt-get update -qq \
#   && apt-get install -yq $buildDeps libc6-i386 \
#   && set -x \
#   && echo "===> Install Go..." \
#   && ARCH="$(dpkg --print-architecture)" \
#   && wget https://storage.googleapis.com/golang/go$GO_VERSION.linux-$ARCH.tar.gz -O /tmp/go.tar.gz \
#   && tar -C /usr/local -xzf /tmp/go.tar.gz \
#   && export PATH=$PATH:/usr/local/go/bin \
#   && echo "===> Building avscan Go binary..." \
#   && cd /go/src/github.com/malice-plugins/bitdefender \
#   && export GOPATH=/go \
#   && go version \
#   && go get \
#   && go build -ldflags "-X main.Version=$(cat VERSION) -X main.BuildTime=$(date -u +%Y%m%d)" -o /bin/avscan \
#   && echo "===> Clean up unnecessary files..." \
#   && apt-get purge -y --auto-remove $buildDeps \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /go /usr/local/go

# Update Bitdefender definitions
# RUN echo "accept" | bdscan --update

# Add EICAR Test Virus File to malware folder
ADD http://www.eicar.org/download/eicar.com.txt /malware/EICAR

WORKDIR /malware

# ENTRYPOINT ["/bin/avscan"]
# CMD ["--help"]
