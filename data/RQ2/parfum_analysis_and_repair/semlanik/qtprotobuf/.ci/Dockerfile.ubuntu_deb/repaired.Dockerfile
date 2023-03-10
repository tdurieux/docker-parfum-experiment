FROM qtprotobuf/ubuntu-latest-builtin-qt:latest
ADD . /sources
RUN mkdir -p /build && mkdir -p /artifacts
WORKDIR /build
RUN cmake ../sources -DQT_PROTOBUF_MAKE_TESTS=FALSE -DQT_PROTOBUF_MAKE_EXAMPLES=FALSE -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_SHARED_LIBS=ON
RUN cpack -G DEB