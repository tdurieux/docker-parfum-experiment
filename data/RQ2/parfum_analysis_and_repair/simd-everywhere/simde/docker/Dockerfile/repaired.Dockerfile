# Dockerfile for SIMDe development

ARG RELEASE=testing
FROM debian:${RELEASE}-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG QEMU_GIT=n

RUN \
  apt-get update -y && \
  apt-get install --no-install-recommends -y netselect-apt && \
  if netselect-apt -n ${release}; then \
    mv sources.list /etc/apt/sources.list; \
  fi && rm -rf /var/lib/apt/lists/*;

COPY docker/bin /tmp/simde-bin
RUN \
  for script in simde-reset-build.sh; do \
    ln -s /usr/local/src/simde/docker/bin/"${script}" /usr/bin/"${script}"; \
  done

# Multiarch
RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  for arch in armhf arm64 ppc64el s390x i386 mips64el; do \
    dpkg --add-architecture "$arch"; \
  done; \
  apt-get update -y

# Common packages
RUN \
  apt-get update -y && \
  apt-get install --no-install-recommends -yq \
    git build-essential \
    cmake ninja-build \
    '^clang-[0-9\.]+$' \
    '^g(cc|\+\+)-[0-9\.]+$' \
    gdb valgrind \
    qemu binfmt-support qemu-user-static \
    creduce screen htop parallel nano rsync strace \
    npm libsleef-dev \
    python3-pip && rm -rf /var/lib/apt/lists/*;

# Meson on stable is too old, and we want to make sure we keep 0.54
# working for a while.
RUN pip3 install --no-cache-dir meson==0.55.0

# GCC cross-compilers
RUN \
  apt-get update -y && \
  apt-get install --no-install-recommends -y apt-file && \
  apt-file update && \
  PACKAGES_TO_INSTALL=""; \
  for ARCH in $(dpkg --print-foreign-architectures); do \
    PACKAGES_TO_INSTALL="${PACKAGES_TO_INSTALL} libc6:${ARCH} ^libstdc\+\+\-[0-9]+\-dev:${ARCH}"; \
    for pkg in $(apt-file search -x "/usr/bin/$(/tmp/simde-bin/arch2gcc.sh ${ARCH})-g(cc|\+\+)-[0-9\.]+" | grep -Po '^([^ ]+)(?<!:)'); do \
      PACKAGES_TO_INSTALL="${PACKAGES_TO_INSTALL} ${pkg}"; \
    done; \
  done; \
  apt-get install --no-install-recommends -yq ${PACKAGES_TO_INSTALL} && rm -rf /var/lib/apt/lists/*;

# ICC
RUN \
  apt-get update -y && \
  apt-get install --no-install-recommends -yq curl gpg && \
  wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
   | gpg --batch --dearmor > /usr/share/keyrings/oneapi-archive-keyring.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list && \
  apt-get update && \
  apt-get install --no-install-recommends -yq intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic && \
  for exe in icc icpc; do \
    printf '#!/bin/bash\nARGS="$@"\nsource /opt/intel/oneapi/compiler/latest/env/vars.sh >/dev/null\n%s ${ARGS}\n' "${exe}" > /usr/bin/"${exe}" && \
    chmod 0755 /usr/bin/"${exe}" ; \
  done && rm -rf /var/lib/apt/lists/*;

# # xlc -- Install fails.
# # Once IBM releases a version for Ubuntu Focal (20.04) I hope I can
# # get this working.
# RUN \
#   curl -s 'https://public.dhe.ibm.com/software/server/POWER/Linux/xl-compiler/eval/ppc64le/ubuntu/public.gpg' | apt-key add - && \
#   echo "deb [arch=ppc64el] https://public.dhe.ibm.com/software/server/POWER/Linux/xl-compiler/eval/ppc64le/ubuntu/ bionic main" > /etc/apt/sources.list.d/xlc.list && \
#   apt-get update && \
#   XLC_VERSION="$(apt-cache search '^xlc\.[0-9]+\.[0-9]+\.[0-9]+$' | awk '{ print substr($1, 5) }')" && \
#   apt-get install "xlc.${XLC_VERSION}:ppc64el" "xlc-license-community.${XLC_VERSION}:ppc64el" && \
#   /opt/ibm/xlC/${XLC_VERSION}/bin/xlc_configure <<< 1 >/dev/null

# Intel SDE
COPY test/download-sde.sh /tmp/simde-bin/download-sde.sh
RUN \
  "/tmp/simde-bin/download-sde.sh" "/opt/intel/sde" && \
  for executable in sde sde64; do \
    ln -s "/opt/intel/sde/${executable}" "/usr/bin/${executable}"; \
  done

# Emscripten
RUN \
  git clone https://github.com/emscripten-core/emsdk.git /opt/emsdk && \
  cd /opt/emsdk && ./emsdk update-tags && ./emsdk install tot && ./emsdk activate tot && \
  ln -s /opt/emsdk/upstream/bin/wasm-ld /usr/bin/wasm-ld && \
  npm install jsvu -g && jsvu --os=linux64 --engines=v8 && ln -s "/root/.jsvu/v8" "/usr/bin/v8" && npm cache clean --force;

# Meson cross files
RUN \
  mkdir -p "/usr/local/share/meson/cross" && ln -s /usr/local/src/simde/docker/cross-files /usr/local/share/meson/cross/simde

# Install QEMU git (necessary for MIPS)
RUN \
  if [ ${QEMU_GIT} = "y" ]; then \
    apt-get install --no-install-recommends -y pkg-config libglib2.0-dev libpixman-1-dev && \
    git clone https://gitlab.com/qemu-project/qemu.git /usr/local/src/qemu && \
    mkdir -p /usr/local/src/qemu/build && cd /usr/local/src/qemu/build && \
    ../configure --prefix=/opt/qemu && \
    make -j$(nproc) && \
    make install; rm -rf /var/lib/apt/lists/*; \
    rm -rf /usr/local/src/qemu; \
  fi

RUN mkdir -p /opt/simde
WORKDIR /opt/simde
