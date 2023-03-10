FROM ubuntu:16.04 as base

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install curl cmake file git build-essential xz-utils software-properties-common apt-transport-https && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL --retry 10 --retry-delay 60 https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main"
RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install clang-9 && ln -s /usr/bin/clang-9 /usr/bin/clang && ln -s /usr/bin/clang++-9 /usr/bin/clang++ && rm -rf /var/lib/apt/lists/*;

RUN git clone -q --depth 1 https://github.com/tpoechtrager/osxcross.git
RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install automake libxml2-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY MacOSX10.15.sdk.tar.xz /osxcross/tarballs/MacOSX10.15.sdk.tar.xz

RUN cd /osxcross && OSX_VERSION_MIN=10.12 UNATTENDED=1 ./build.sh
RUN cd /osxcross && ./target/bin/o64-clang++-libc++ -o osxcross ./oclang/test_libcxx.cpp


FROM therecipe/qt:darwin_static_base
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work
ENV PATH /usr/local/go/bin:$PATH
ENV QT_API 5.13.0
ENV QT_DOCKER true
ENV QT_STATIC true
ENV QT_VERSION $QT_API
ENV QT_QMAKE_DIR $GOPATH/src/github.com/therecipe/env_darwin_amd64_513/5.13.0/clang_64/bin


RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install curl git build-essential libglib2.0-dev software-properties-common apt-transport-https && apt-get -qq clean && rm -rf /var/lib/apt/lists/*;

COPY --from=base /osxcross/target /osxcross/target
RUN ln -s /osxcross/target/bin/xcrun /usr/bin/xcrun
RUN rm /usr/bin/strip && ln -s /osxcross/target/bin/x86_64-apple-darwin19-strip /usr/bin/strip
RUN ln -s /osxcross/target/bin/x86_64-apple-darwin19-otool /usr/bin/otool
RUN ln -s /osxcross/target/bin/x86_64-apple-darwin19-install_name_tool /usr/bin/install_name_tool

RUN GO=go1.13.4.linux-amd64.tar.gz && curl -f -sL --retry 10 --retry-delay 60 -O https://dl.google.com/go/$GO && tar -xzf $GO -C /usr/local
RUN go get github.com/therecipe/qt/cmd/...
RUN DST=$GOPATH/src/github.com/therecipe/env_darwin_amd64_513/5.13.0/clang_64/bin && rm -r $DST && cp -r $GOPATH/src/github.com/therecipe/env_linux_amd64_513/5.13.0/gcc_64/bin $DST

RUN sed -i -e 's/error/warning/g' $GOPATH/src/github.com/therecipe/env_darwin_amd64_513/5.13.0/clang_64/mkspecs/features/mac/default_pre.prf
RUN sed -i -e 's/$$QMAKE_MAC_SDK_PATH/$$(QMAKE_MAC_SDK_PATH)/g' $GOPATH/src/github.com/therecipe/env_darwin_amd64_513/5.13.0/clang_64/mkspecs/features/mac/default_post.prf
ENV QMAKE_MAC_SDK_PATH /osxcross/target/SDK/MacOSX10.15.sdk

RUN curl -f -sL --retry 10 --retry-delay 60 https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main"
RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install clang-9 && apt-get -qq clean && ln -s /usr/bin/clang-9 /usr/bin/clang && ln -s /usr/bin/clang++-9 /usr/bin/clang++ && rm -rf /var/lib/apt/lists/*;

ENV LD_LIBRARY_PATH $GOPATH/src/github.com/therecipe/env_linux_amd64_513/5.13.0/gcc_64/lib
ENV QT_PLUGIN_PATH $GOPATH/src/github.com/therecipe/env_linux_amd64_513/5.13.0/gcc_64/plugins
ENV CC /osxcross/target/bin/x86_64-apple-darwin19-clang
ENV CXX /osxcross/target/bin/x86_64-apple-darwin19-clang++

RUN $GOPATH/bin/qtsetup prep darwin
RUN $GOPATH/bin/qtsetup check darwin
RUN $GOPATH/bin/qtsetup generate darwin
RUN cd $GOPATH/src/github.com/therecipe/qt/internal/examples/widgets/line_edits && $GOPATH/bin/qtdeploy build darwin && rm -rf ./deploy

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install ca-certificates git pkg-config && rm -rf /var/lib/apt/lists/*;


ENV PATH $HOME/flutter/bin:$PATH

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install curl unzip && apt-get -qq clean && rm -rf /var/lib/apt/lists/*;
RUN git clone -q --depth 1 -b stable https://github.com/flutter/flutter.git $HOME/flutter
RUN flutter config --no-analytics && flutter precache --linux --no-android