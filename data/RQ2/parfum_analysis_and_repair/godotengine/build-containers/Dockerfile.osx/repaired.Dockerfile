ARG img_version
FROM godot-mono:${img_version}

ARG mono_version

RUN if [ -z "${mono_version}" ]; then echo -e "\n\nargument mono-version is mandatory!\n\n"; exit 1; fi && \
    dnf -y install --setopt=install_weak_deps=False \
      automake autoconf bzip2-devel cmake libicu-devel libtool libxml2-devel openssl-devel yasm && \
    git clone --progress https://github.com/tpoechtrager/osxcross.git && \
    cd /root/osxcross && \
    git checkout 17bb5e2d0a46533c1dd525cf4e9a80d88bd9f00e && \
    ln -s /root/files/MacOSX12.3.sdk.tar.xz /root/osxcross/tarballs && \
    export UNATTENDED=1 && \
    # Custom build to ensure we have Clang version matching Xcode SDK.
    CLANG_VERSION=13.0.1 ENABLE_CLANG_INSTALL=1 INSTALLPREFIX=/usr ./build_clang.sh && \
    ./build.sh && \
    ./build_compiler_rt.sh && \
    rm -rf /root/osxcross/build

ENV OSXCROSS_ROOT=/root/osxcross
ENV PATH="/root/osxcross/target/bin:${PATH}"

RUN cp -a /root/files/${mono_version} /root && \
    cd /root/${mono_version} && \
    patch -p1 < /root/files/patches/mono-btls-cmake-wrapper.patch && \
    export MONO_SOURCE_ROOT=/root/${mono_version} && \
    export OSXCROSS_SDK=21.4 && \
    cd /root/${mono_version}/godot-mono-builds && \
    python3 osx.py configure -j --target=x86_64 --target=arm64 && \
    python3 osx.py make -j --target=x86_64 --target=arm64 && \
    python3 bcl.py make --product=desktop && \
    python3 osx.py copy-bcl --target=x86_64 --target=arm64 && \
    cd /root && \
    rm -rf /root/${mono_version}

CMD /bin/bash