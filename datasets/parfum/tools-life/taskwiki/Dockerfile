ARG ALPINE_VERSION=3.14
ARG PYTHON_VERSION=3.10
ARG TASK_VERSION=stable
ARG VIM_VERSION=v8.2.5172
ARG VIMWIKI_VERSION=master


FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION} AS build


FROM build AS build-vim
RUN apk add --no-cache \
    gcc \
    git \
    gtk+3.0-dev \
    libxt-dev \
    make \
    musl-dev \
    ncurses-dev
ARG VIM_VERSION
RUN git clone --depth 1 --recurse-submodules --shallow-submodules \
    --branch $VIM_VERSION https://github.com/vim/vim /usr/src/vim
WORKDIR /usr/src/vim
# "backport" https://github.com/vim/vim/commit/16d7eced1a08565a9837db8067c7b9db5ed68854
RUN sed -i -e '/#\s*undef _POSIX_THREADS/d' src/if_python3.c

# "backport" https://github.com/vim/vim/commit/23c0192166760b0d73bd39252ca72e3cfe596f6e
# This fixes Python3 detection for Python 3.10 and above
RUN sed -i -e 's/import sys; print(sys\.version\[:3\])/import sys; print("{}.{}".format(sys.version_info.major, sys.version_info.minor))/' src/configure.ac src/auto/configure

RUN ./configure --prefix=/opt/vim --enable-pythoninterp=yes --enable-python3interp=yes --enable-gui=gtk3
RUN make -j$(nproc)
RUN make install


FROM build AS build-taskwarrior
RUN apk add --no-cache \
    cmake \
    g++ \
    gcc \
    git \
    make \
    util-linux-dev
ARG TASK_VERSION
RUN git clone --depth 1 --recurse-submodules --shallow-submodules \
    --branch $TASK_VERSION https://github.com/GothenburgBitFactory/taskwarrior /usr/src/taskwarrior
WORKDIR /usr/src/taskwarrior
RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/taskwarrior -DCMAKE_BUILD_TYPE=release -DENABLE_SYNC=OFF .
RUN make -j$(nproc)
RUN make install


FROM build AS build-pip
# coverage needs to build a C extensions, otherwise it's slow
RUN apk add --no-cache \
    gcc \
    linux-headers \
    musl-dev
RUN pip install --root=/opt/pip-root \
    coverage \
    coveralls \
    pytest \
    pytest-cov \
    pytest-xdist \
    https://github.com/liskin/vimrunner-python/archive/8c19ff88050c09236e7519425bfae33c687483df.zip
COPY requirements.txt /tmp/taskwiki/requirements.txt
RUN pip install --root=/opt/pip-root \
    -r /tmp/taskwiki/requirements.txt


FROM build AS tests
# Terminus-font required for gvim to run
RUN apk add --no-cache \
    git \
    make \
    patchelf \
    terminus-font \
    tzdata \
    xvfb-run
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

COPY --from=build-vim /opt/vim/ /opt/vim/
COPY --from=build-taskwarrior /opt/taskwarrior/ /opt/taskwarrior/
COPY --from=build-pip /opt/pip-root/ /

# install runtime deps of vim/taskwarrior
RUN patchelf --print-needed /opt/*/bin/* \
  | grep -v '^libpython' \
  | sort -u \
  | sed -e 's/^/so:/' \
  | xargs -rt apk add --no-cache
ENV PATH=/opt/vim/bin:/opt/taskwarrior/bin:$PATH
RUN task --version && vim --version

ARG VIMWIKI_VERSION
RUN git clone --depth 1 --recurse-submodules --shallow-submodules \
    --branch $VIMWIKI_VERSION https://github.com/vimwiki/vimwiki /root/.vim/bundle/vimwiki

# Fixes coveralls reporting
RUN git config --global --add safe.directory /root/.vim/bundle/taskwiki

WORKDIR /root/.vim/bundle/taskwiki
