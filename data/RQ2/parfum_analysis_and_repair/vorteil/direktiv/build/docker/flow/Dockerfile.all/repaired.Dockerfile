FROM ubuntu:21.04 as libgit

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get clean && apt-get update

RUN apt-get install --no-install-recommends libmbedtls-dev git cmake build-essential pkg-config libssl-dev \
         python3 zlib1g-dev libmbedtls-dev libpcre3 libpcre3-dev wget -y && rm -rf /var/lib/apt/lists/*;

# build libssh
RUN wget https://www.libssh2.org/download/libssh2-1.10.0.tar.gz && tar -xvzf libssh2-1.10.0.tar.gz && rm libssh2-1.10.0.tar.gz
RUN cd libssh2-1.10.0 && mkdir bin && cd bin && cmake .. -DENABLE_ZLIB_COMPRESSION=ON -DBUILD_SHARED_LIBS=ON && cmake --build . --target install

RUN git clone -b v1.3.0 https://github.com/libgit2/libgit2.git

# build libgit
RUN mkdir libgit2/build && cd libgit2/build
RUN cd libgit2/build && cmake .. -DUSE_SSH=ON
RUN cd libgit2/build && cmake --build . --target install

FROM libgit as golang

ARG RELEASE_VERSION
ENV RELEASE=$RELEASE_VERSION

RUN wget https://go.dev/dl/go1.18.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz && rm go1.18.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

COPY go.mod src/go.mod
COPY go.sum src/go.sum
RUN cd src/ && go mod download

ENV LD_LIBRARY_PATH=/usr/local/lib/
COPY pkg src/pkg/
COPY cmd src/cmd/
COPY .git .git

RUN --mount=type=cache,target=/root/.cache/go-build cd src && \
    export GIT_HASH=`git rev-parse --short HEAD` && \
    export FULL_VERSION="${RELEASE}${RELEASE:+-}${GIT_HASH}"; echo "${v%.*}" && \
    go build -ldflags "-X github.com/direktiv/direktiv/pkg/version.Version=$FULL_VERSION" -o /flow cmd/flow/*.go;

FROM ubuntu:21.04

COPY --from=libgit /usr/local/lib/libssh2.so.1.0.1 /lib/x86_64-linux-gnu/libssh2.so.1.0.1
RUN ln -s /lib/x86_64-linux-gnu/libssh2.so.1.0.1 /lib/x86_64-linux-gnu/libssh2.so.1
RUN ln -s /lib/x86_64-linux-gnu/libssh2.so.1 /lib/x86_64-linux-gnu/libssh2.so

COPY --from=libgit /usr/local/lib/libgit2.so.1.3.0 /lib/x86_64-linux-gnu/
RUN ln -s /lib/x86_64-linux-gnu/libgit2.so.1.3.0 /lib/x86_64-linux-gnu/libgit2.so.1.3
RUN ln -s /lib/x86_64-linux-gnu/libgit2.so.1.3 /lib/x86_64-linux-gnu/libgit2.so

EXPOSE 6666
EXPOSE 7777

COPY --from=golang /flow /bin/direktiv

CMD ["/bin/direktiv"]