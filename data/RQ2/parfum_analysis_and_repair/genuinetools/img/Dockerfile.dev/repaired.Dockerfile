FROM ubuntu:bionic AS base

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		wget \
		pkg-config \
		git \
		curl \
		ca-certificates \
		libseccomp-dev \
		uidmap \
		parallel \
		pigz \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.13.10

RUN set -eux; \

# this "case" statement is generated via "update.sh"
	dpkgArch="$(dpkg --print-architecture)"; \
	case "${dpkgArch##*-}" in \
		amd64) goRelArch='linux-amd64'; goRelSha256='8a4cbc9f2b95d114c38f6cbe94a45372d48c604b707db2057c787398dfbf8e7f' ;; \
		armhf) goRelArch='linux-armv6l'; goRelSha256='3c581f11ed49eaf0954f62ffebc123f8c392fc536f01c5a44cb38185701101fc' ;; \
		arm64) goRelArch='linux-arm64'; goRelSha256='f16f19947855b410e48f395ca488bd39223c7b35e8b69c7f15ec00201e20b572' ;; \
		i386) goRelArch='linux-386'; goRelSha256='233c9d43fe2fab27ee489efea08b84665aec5855cce95a81dba3846636de5fed' ;; \
		ppc64el) goRelArch='linux-ppc64le'; goRelSha256='6b9505388ecafa3cb04d5f51638276b25f7d80c5f70bd74ed72f8013f5006fd9' ;; \
		s390x) goRelArch='linux-s390x'; goRelSha256='41cb67266e809920363ff620e8cabce152ab54bebd6a337e9f903f5c1996ec35' ;; \
		*) goRelArch='src'; goRelSha256='eb9ccc8bf59ed068e7eff73e154e4f5ee7eec0a47a610fb864e3332a2fdc8b8c'; \
			echo >&2; echo >&2 "warning: current architecture ($dpkgArch) does not have a corresponding Go binary release; will be building from source"; echo >&2 ;; \
	esac; \

	url="https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz"; \
	wget -O go.tgz "$url"; \
	echo "${goRelSha256}  *go.tgz" | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \

	if [ "$goRelArch" = 'src' ]; then \
		echo >&2; \
		echo >&2 'error: UNIMPLEMENTED'; \
		echo >&2 'TODO install golang-any from jessie-backports for GOROOT_BOOTSTRAP (and uninstall after build)'; \
		echo >&2; \
		exit 1; \
	fi; \

	export PATH="/usr/local/go/bin:$PATH"; \
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN go get golang.org/x/lint/golint \
    && go get honnef.co/go/tools/cmd/staticcheck \
    && go get github.com/go-bindata/go-bindata/go-bindata \
    && go get github.com/go-delve/delve/cmd/dlv

# We don't use the bionic shadow pkg bacause:
# 1. To allow running img in a container without CAP_SYS_ADMIN, we need to do either
#     a) install newuidmap/newgidmap with file capabilities rather than SETUID (requires kernel >= 4.14)
#     b) install newuidmap/newgidmap >= 20181125 (59c2dabb264ef7b3137f5edb52c0b31d5af0cf76)
#    We choose b) until kernel >= 4.14 gets widely adopted.
#    See https://github.com/shadow-maint/shadow/pull/132 https://github.com/shadow-maint/shadow/pull/138 https://github.com/shadow-maint/shadow/pull/141
FROM base AS idmap
RUN apt-get update && apt-get install -y --no-install-recommends \
      autoconf \
      automake \
      autopoint \
      byacc \
      gettext \
      libcap-dev \
      libtool \
      libxslt1-dev \
	  && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/shadow-maint/shadow.git /shadow
WORKDIR /shadow
RUN git checkout 59c2dabb264ef7b3137f5edb52c0b31d5af0cf76
RUN ./autogen.sh --disable-nls --disable-man --without-audit --without-selinux --without-acl --without-attr --without-tcb --without-nscd \
  && make \
  && cp src/newuidmap src/newgidmap /usr/bin

FROM base

COPY --from=idmap /usr/bin/newuidmap /usr/bin/newuidmap
COPY --from=idmap /usr/bin/newgidmap /usr/bin/newgidmap
RUN chmod u+s /usr/bin/newuidmap /usr/bin/newgidmap \
  && useradd -u 1000 --home-dir /home/user user \
  && mkdir -p /run/user/1000 \
  && mkdir -p /home/user \
  && chown -R user /run/user/1000 /home/user \
  && chown -R user /go \
  && echo user:100000:65536 | tee /etc/subuid | tee /etc/subgid

USER user
ENV USER user
ENV HOME /home/user
ENV XDG_RUNTIME_DIR=/run/user/1000

WORKDIR /home/user