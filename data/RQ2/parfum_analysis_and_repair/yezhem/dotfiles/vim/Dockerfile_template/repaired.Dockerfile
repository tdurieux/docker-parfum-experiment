FROM ubuntu:18.04

MAINTAINER yezhengmao <yezhengmaolove@gmail.com>

ENV USER_HOME="/home/user" \
    PYENV_ROOT="/usr/local/pyenv" \
    PATH="/usr/local/go/bin:/usr/local/pyenv/shims:/usr/local/pyenv/bin:$PATH" \
    BUILD_DIR="/workspace" \
    COMPILE_DIR="/compile"

COPY {pkg-cache} $BUILD_DIR

RUN useradd user -u {uid} -g {gid} -d $USER_HOME -s /bin/bash \
# install and update app from deb
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" TZ="Asia/Shanghai" \
       apt-get install -y --no-install-recommends \ 
       {ubuntu-pkg} \
# install pyenv and python
    && mkdir -p $PYENV_ROOT/cache \
    && tar -zxf $BUILD_DIR/{pyenv-name} -C $PYENV_ROOT --strip-components 1 \
    && mv $BUILD_DIR/{python-name} $PYENV_ROOT/cache/{python-name} \
    && {pyenv-compile-args} pyenv install -v {python-ver} \
    && pyenv global {python-ver} \
# compile/install cmake
    && mkdir -p $COMPILE_DIR/CMake \
    && tar -zxf $BUILD_DIR/{cmake-name} -C $COMPILE_DIR/CMake --strip-components 1 \
    && cd $COMPILE_DIR/CMake \
    && ./bootstrap \
    && make -j8 \
    && make install \
# install llvm and clang
    && tar -xf $BUILD_DIR/{llvm-name} -C /usr/local --strip-components 1 \
# install go
    && tar -xzf $BUILD_DIR/{go-name} -C /usr/local \
# install fzf
    && tar -xzf $BUILD_DIR/{fzf-name} -C /usr/local/bin \
# compile/install abseil
    && mkdir -p $COMPILE_DIR/absl \
    && tar -zxf $BUILD_DIR/{absl-name} -C $COMPILE_DIR/absl --strip-components 1 \
    && cd $COMPILE_DIR/absl \
    && cmake {absl-compile-args} . \
    && make -j8 \
    && make install \
# compile/install cppinsight
    && mkdir -p $COMPILE_DIR/insight \
    && tar -zxf $BUILD_DIR/{insight-name} -C $COMPILE_DIR/insight --strip-components 1 \
    && cd $COMPILE_DIR/insight \
    && cmake {insight-compile-args} . \
    && make -j8 \
    && make install \
# compile/install vim82
    && mkdir -p $COMPILE_DIR/vim \
    && tar -zxf $BUILD_DIR/{vim-name} -C $COMPILE_DIR/vim --strip-components 1 \
    && cd $COMPILE_DIR/vim \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" {vim-compile-args} \
    && make VIMRUNTIMEDIR=/usr/local/share/vim/vim82 -j8 \
    && make install \
# install vim plugins
    && mkdir -p $USER_HOME/.vim/autoload $USER_HOME/.vim/bundle $USER_HOME/.vim/plugin \
    && cd $BUILD_DIR \
    && mv {vim-config} $USER_HOME/.vimrc \
    && mv {vim-plugins} $USER_HOME/.vim/plugin \
    && mv {vim-autoloads} $USER_HOME/.vim/autoload \
    && mv {vim-bundles} $USER_HOME/.vim/bundle \
# compile youcompleteme
    && cd $USER_HOME/.vim/bundle/YouCompleteMe \
    && EXTRA_CMAKE_ARGS="-DUSE_SYSTEM_ABSEIL=1" CXX="/usr/local/bin/clang++" python3 ./install.py --system-libclang --clang-completer \
# clean env
    && rm -rf $BUILD_DIR \
    && rm -rf $COMPILE_DIR \
    && chown {uid}:{gid} -R $USER_HOME && rm -rf /var/lib/apt/lists/*;

USER user
