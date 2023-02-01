# MIT License
#
# Copyright (c) 2020 Dmitrii Ustiugov, Shyam Jesalpura and EASE lab
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM kindest/node:v1.23.5

RUN apt-get update && \
    apt-get upgrade --yes && \
    apt-get install --no-install-recommends --yes \
    apt-utils && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install --yes \
    sudo \
    gnupg2 \
    wget curl \
    gcc g++ \
    iproute2 iptables net-tools nftables \
    apt-transport-https \
    ca-certificates \
    make jq \
    acl \
    git git-lfs \
    bc \
    dmsetup \
    gnupg-agent \
    apt-transport-https software-properties-common pkg-config \
    libseccomp-dev libseccomp2 \
    unzip tar \
    socat \
    util-linux \
    ipvsadm \
    gettext-base \
    skopeo \
    tmux vim && \
    sudo wget -O /usr/local/bin/kn -c "https://github.com/knative/client/releases/download/v0.20.0/kn-linux-amd64" && \
    sudo chmod +x /usr/local/bin/kn && \
    mkdir /scripts && rm -rf /var/lib/apt/lists/*;

COPY scripts/github_runner/setup_cri_dev_env.sh /scripts/
COPY scripts/setup_system.sh /scripts/
COPY scripts/create_devmapper.sh /scripts/
COPY configs/kind/kubeadm.conf /scripts/
RUN chmod +x /scripts/setup_system.sh && \
    chmod +x /scripts/create_devmapper.sh && \
    chmod +x /scripts/setup_cri_dev_env.sh

ENTRYPOINT ["/usr/local/bin/entrypoint","/scripts/setup_cri_dev_env.sh","/sbin/init"]
