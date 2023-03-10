FROM qtprotobuf/opensuse-latest-qt:latest
ADD . /sources
RUN mkdir -p /build
WORKDIR /build
ENV PATH=/qt/5.15.2/gcc_64/bin:$PATH
RUN cmake ../sources -DCMAKE_PREFIX_PATH="/qt/5.15.2/gcc_64/lib/cmake" -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release
RUN cmake --build .
ENV QT_PLUGIN_PATH=/qt/5.15.2/gcc_64/plugins
ENV QT_QPA_PLATFORM=minimal