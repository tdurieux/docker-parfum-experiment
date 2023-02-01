FROM idoall/ubuntu16.04-golang:1.4
MAINTAINER lion <lion.net@163.com>


ENV GOLANG_VERSION 1.7.4


# -----------------------------------------------------------------------------
# 下载 golang
# -----------------------------------------------------------------------------
RUN set -eux \
	&& axel -n 10 -o /home/work/_src/go.tgz https://storage.googleapis.com/golang/go$GOLANG_VERSION.src.tar.gz \
	&& echo '4c189111e9ba651a2bb3ee868aa881fab36b2f2da3409e80885ca758a6b614cc /home/work/_src/go.tgz' | sha256sum -c - \
	&& tar -C /home/work/_app -xzf /home/work/_src/go.tgz \
	&& cd /home/work/_app/go/src \
	&& export GOPATH=/home/work/_src/golang \
	&& export GOROOT=/home/work/_app/go1.4 \
	&& export GOOS="$(go env GOOS)" \
	&& export GOARCH="$(go env GOARCH)" \
	&& export GO386="$(go env GO386)" \
	&& export GOARM="$(go env GOARM)" \
	&& export GOHOSTOS="$(go env GOHOSTOS)" \
	&& export GOHOSTARCH="$(go env GOHOSTARCH)" \
	&& export GOROOT_BOOTSTRAP=/home/work/_app/go1.4 \
	&& export GOBIN=$GOROOT/bin \
	&& ./bootstrap.bash \
	&& ./make.bash \
	&& cd /home/work/_app \
	&& mv /home/work/_app/go /home/work/_app/go$GOLANG_VERSION \
	&& rm -rf /home/work/_app/go-linux-amd64-bootstrap.tbz
	


# -----------------------------------------------------------------------------
# 清除
# -----------------------------------------------------------------------------
RUN chmod 755 /hooks \
	&& chown -R work:work /home/work/* \
	&& apt-get -y clean \
  	&& rm -rf /var/lib/apt/lists/* \
  	&& rm -rf /var/cache/apt/archives/apt-fast/* \
  	&& rm -rf /home/work/_src/*

ENV GOPATH /home/work/_project/golang
ENV GOROOT /home/work/_app/go$GOLANG_VERSION
ENV GOROOT_BOOTSTRAP $GOROOT
ENV GOBIN $GOROOT/bin
ENV PATH /home/work/_app/go$GOLANG_VERSION/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

