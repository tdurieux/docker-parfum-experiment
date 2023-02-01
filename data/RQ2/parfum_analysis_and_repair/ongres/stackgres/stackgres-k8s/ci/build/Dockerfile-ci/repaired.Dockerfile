####
# This Dockerfile is used in order to build a container that runs the StackGres ITs
#
# Build the image with:
#
# docker build -f stackgres-k8s/ci/build/Dockerfile-ci -t registry.gitlab.com/ongresinc/stackgres/ci-amd64:1.11 stackgres-k8s/ci/build/
#
###

FROM docker.io/docker:20.10
   RUN apk add --no-cache coreutils gnupg openssl jq curl bash zsh sed libc6-compat
    RUN apk add --no-cache attr-dev e2fsprogs-dev glib-dev libtirpc-dev openssl-dev util-linux-dev \
      gcc libc-dev make automake autoconf libtool linux-headers
    RUN wget -q https://github.com/zfsonlinux/zfs/releases/download/zfs-0.8.4/zfs-0.8.4.tar.gz -O -|tar xz
    RUN cd zfs-0.8.4 \
      && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr \
        --with-tirpc \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --localstatedir=/var \
        --with-config=user \
        --with-udevdir=/lib/udev \
        --disable-systemd \
        --disable-static \
      && make install
    RUN uname -a | grep -qxF aarch64 \
      || wget -q -O /bin/yajsv https://github.com/neilpa/yajsv/releases/download/v1.4.0/yajsv.linux.amd64
    RUN chmod a+x /bin/yajsv
    RUN apk add --no-cache py3-pip
    RUN pip3 install --no-cache-dir yamllint yq
    RUN mkdir -p "$HOME/.docker"; echo '{"experimental":"enabled"}' > "$HOME/.docker/config.json"
    RUN apk add --no-cache git
    RUN apk add --no-cache xz
    RUN mkdir -p ~/.docker/cli-plugins
    RUN wget -q -O ~/.docker/cli-plugins/docker-buildx "https://github.com/docker/buildx/releases/download/v0.7.1/buildx-v0.7.1.linux-$(uname -m | grep -qxF aarch64 && echo arm64 || echo amd64)"
    RUN chmod a+x ~/.docker/cli-plugins/docker-buildx
    RUN echo '{"experimental":"enabled"}' > ~/.docker/config.json
    RUN wget -q -O /bin/kubectl "https://dl.k8s.io/release/v1.21.3/bin/linux/$(uname -m | grep -qxF aarch64 && echo arm64 || echo amd64)/kubectl"
    RUN chmod a+x /bin/kubectl
    RUN wget -q -O /bin/kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.11.1/kind-linux-$(uname -m | grep -qxF aarch64 && echo arm64 || echo amd64)"
    RUN chmod a+x /bin/kind
    RUN wget -q -O /bin/k3d "https://github.com/rancher/k3d/releases/download/v4.4.7/k3d-linux-$(uname -m | grep -qxF aarch64 && echo arm64 || echo amd64)"
    RUN chmod a+x /bin/k3d
    RUN wget -q "https://get.helm.sh/helm-v3.7.2-linux-$(uname -m | grep -qxF aarch64 && echo arm64 || echo amd64).tar.gz" -O -|tar xz --strip-components=1 -C /bin -f - "linux-$(uname -m | grep -qxF aarch64 && echo arm64 || echo amd64)/helm"
    RUN apk add --no-cache aws-cli
