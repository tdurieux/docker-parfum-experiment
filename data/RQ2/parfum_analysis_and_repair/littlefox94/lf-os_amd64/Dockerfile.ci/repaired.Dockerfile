ARG debianVersion=bookworm

# can be local or repo, local adds a file lf_os-toolchain_*_amd64.deb, repo loads from apt repository
ARG toolchainSource=repo

FROM debian:$debianVersion AS build_local
ONBUILD COPY lf_os-toolchain_*_amd64.deb /tmp/lf_os-toolchain.deb
ONBUILD RUN  dpkg -i /tmp/lf_os-toolchain.deb                                      ;  \
             apt-get -qq update                                                    && \
             apt-get -qq install -y -f --no-install-recommends                     && \
             rm /tmp/lf_os-toolchain.deb

FROM debian:$debianVersion AS build_repo
 \
RUN apt-get -qq update && \
             apt-get -qq -y install --no-install-recommends \
                curl gnupg2 ca-certificates apt-transport-https && \
             echo "deb [arch=amd64] https://apt.svc.0x0a.network unstable lf-os"      \
                 > /etc/apt/sources.list.d/lf-os.list && \
             curl -f -sSL https://apt.svc.0x0a.network/public_key.gpg | apt-key add - && \
             apt-get -qq update && \
             apt-get -qq install -y --no-install-recommends lf_os-toolchain && rm -rf /var/lib/apt/lists/*; ONBUILD








FROM build_$toolchainSource

RUN apt-get -qq update                                                             && \
    apt-get -qq install -y --no-install-recommends                                    \
        xz-utils gdisk python3-distutils                                              \
        make ninja-build cmake doxygen graphviz                                       \
        libyaml-perl python3 git gcc g++ libgtest-dev && \
    ln -s /opt/lf_os/toolchain/bin/ld.lld /usr/local/bin/ld && rm -rf /var/lib/apt/lists/*;
