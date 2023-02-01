FROM ubuntu:18.04

RUN apt-get update; \
		apt-get install -y --no-install-recommends software-properties-common; rm -rf /var/lib/apt/lists/*; \
		add-apt-repository --yes ppa:ubuntu-toolchain-r/test; \
		apt-get update;


# Go
RUN apt-get install --no-install-recommends -y golang-1.10 git build-essential; rm -rf /var/lib/apt/lists/*; \
		ln -s /usr/lib/go-1.10/bin/go /bin/go; \
		ln -s /usr/lib/go-1.10/bin/gofmt /bin/gofmt

# gcc

RUN apt-get install --no-install-recommends -y gcc g++ && rm -rf /var/lib/apt/lists/*;
#
RUN apt-get install --no-install-recommends -y curl zlib1g-dev automake \
                      libtool xutils-dev make pkg-config python-pip \
                      libcurl4-openssl-dev \
                      libllvm3.9 \
                      git-lfs; rm -rf /var/lib/apt/lists/*; \
                      apt-get update;

#
RUN apt-get update
RUN apt-get install --no-install-recommends -y cmake cmake-data && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ccache && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglu1-mesa-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libosmesa6-dev libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update

#
#RUN apt-get install -y libxi-dev libglu1-mesa-dev x11proto-randr-dev \
#                     x11proto-xext-dev libxrandr-dev \
#                     x11proto-xf86vidmode-dev libxxf86vm-dev \
#                     libxcursor-dev libxinerama-dev
#
#

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Tools for Development
RUN apt-get install --no-install-recommends -y neovim tree && rm -rf /var/lib/apt/lists/*;

ENV GOPATH=/go
RUN go get \
	 github.com/arolek/p \
	 github.com/go-spatial/geom \
	 github.com/dimfeld/httptreemux \
	 github.com/disintegration/imaging \
	 github.com/spf13/cobra

#RUN go get -d github.com/go-spatial/go-mbgl


#RUN mkdir -p /go/src/github.com/go-spatial/go-mbgl
#WORKDIR  /go/src/github.com/go-spatial/go-mbgl

ENTRYPOINT bash
