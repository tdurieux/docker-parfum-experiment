FROM golang:1.17.3 as osxcross

#ENV ALL_PROXY=http://172.30.144.1:7890

ENV GO111MODULE=auto
ENV GOPROXY=https://goproxy.cn,direct
ENV GOSUMDB=off

RUN git config --global http.sslVerify false
RUN git config --global http.postBuffer 1048576000
RUN git config --global pull.rebase true

RUN go install github.com/goreleaser/goreleaser@latest

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt-get update

# windows
RUN apt-get install --no-install-recommends -y *-w64-* && rm -rf /var/lib/apt/lists/*;

# darwin(amd64/arm64)
RUN apt-get install --no-install-recommends -y clang cmake patch xz-utils zlib1g-dev libmpc-dev libmpfr-dev libgmp-dev libxml2-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone https://hub.fastgit.org/tpoechtrager/osxcross.git --depth=1 /osxcross/
WORKDIR /osxcross
RUN curl -f -o /osxcross/tarballs/MacOSX12.0.sdk.tar.xz "https://raw.githubusercontent.com/troian/golang-cross/master/tars/MacOSX12.0.sdk.tar.xz"
RUN UNATTENDED=1 OCDEBUG=0 /osxcross/build.sh
#RUN #OCDEBUG=0 /osxcross/build_gcc.sh
ENV PATH="$PATH:/osxcross/target/bin/"

WORKDIR /home/
