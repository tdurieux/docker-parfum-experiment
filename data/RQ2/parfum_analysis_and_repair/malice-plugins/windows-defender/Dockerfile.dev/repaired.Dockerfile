FROM ubuntu

LABEL maintainer "https://github.com/blacktop"

ENV GO_VERSION 1.8.3

COPY mpam-fe.exe /tmp/mpam-fe.exe
COPY . /go/src/github.com/maliceio/malice-windows-defender
RUN buildDeps='ca-certificates \
               libreadline-dev:i386 \
               libc6-dev:i386 \
               build-essential \
               gcc-multilib \
               cabextract \
               mercurial \
               git-core \
               unzip \
               wget' \
  && set -x \
  && dpkg --add-architecture i386 && apt-get update -qq \
  && apt-get install -y $buildDeps libc6-i386 --no-install-recommends \
  && echo "===> Install taviso/loadlibrary..." \
  && git clone https://github.com/blacktop/loadlibrary.git /loadlibrary \
  && echo "===> Download 32-bit antimalware update file.." \
  # && wget "http://go.microsoft.com/fwlink/?LinkID=121721&arch=x86" -O \
  #   /loadlibrary/engine/mpam-fe.exe \
  && mv /tmp/mpam-fe.exe /loadlibrary/engine \
  && cd /loadlibrary/engine \
  && cabextract mpam-fe.exe \
  && rm mpam-fe.exe \
  && cd /loadlibrary \
  && make -j2 \
  && echo "===> Install Go..." \
  && ARCH="$(dpkg --print-architecture)" \
  && wget https://storage.googleapis.com/golang/go$GO_VERSION.linux-$ARCH.tar.gz -O /tmp/go.tar.gz \
  && tar -C /usr/local -xzf /tmp/go.tar.gz \
  && export PATH=$PATH:/usr/local/go/bin \
  && echo "===> Building avscan Go binary..." \
  && cd /go/src/github.com/maliceio/malice-windows-defender \
  && export GOPATH=/go \
  && go version \
  && go get \
  && CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-X main.Version=$(cat VERSION) -X main.BuildTime=$(date -u +%Y%m%d)" \
                                          -ldflags '-extldflags "-static --strip-all"' \
                                          -o /bin/avscan \
  && ls -lah /bin/avscan \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps $(apt-mark showauto) \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /go /usr/local/go && rm /tmp/go.tar.gz

# Add EICAR Test Virus File to malware folder
ADD http://www.eicar.org/download/eicar.com.txt /malware/EICAR

WORKDIR /malware

ENTRYPOINT ["/bin/avscan"]
CMD ["--help"]
