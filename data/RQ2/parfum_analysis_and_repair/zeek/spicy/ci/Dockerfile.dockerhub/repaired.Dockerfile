# This Dockerfile is used to create images published to DockerHub. It needs to
# be kept in sync with the corresponding Dockerfile we use and test in CI
# (docker/Dockerfile.ubuntu-20).

FROM ubuntu:focal

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ZEEK_LTS=1
ARG ZEEK_VERSION=4.0.4-0
ARG SPICY_ZKG_PROCESSES=

CMD ["sh"]
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/spicy/bin:/opt/zeek/bin:${PATH}"
ENV SPICY_ZKG_PROCESSES=${SPICY_ZKG_PROCESSES}

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates gnupg2 \
 # Install Zeek.
 && mkdir -p /tmp/zeek-packages \
 && cd /tmp/zeek-packages \
 && if [ -n "${ZEEK_LTS}" ]; then ZEEK_LTS="-lts"; fi && export ZEEK_LTS \
 && apt-get install -y --no-install-recommends libpcap0.8 libpcap-dev libssl-dev zlib1g-dev libmaxminddb0 libmaxminddb-dev python python3 python3-pip python3-semantic-version python3-git \
 && curl -f -L --remote-name-all \
    https://download.zeek.org/binary-packages/xUbuntu_20.04/amd64/zeek${ZEEK_LTS}-core_${ZEEK_VERSION}_amd64.deb \
    https://download.zeek.org/binary-packages/xUbuntu_20.04/amd64/zeekctl${ZEEK_LTS}_${ZEEK_VERSION}_amd64.deb \
    https://download.zeek.org/binary-packages/xUbuntu_20.04/amd64/zeek${ZEEK_LTS}-core-dev_${ZEEK_VERSION}_amd64.deb \
    https://download.zeek.org/binary-packages/xUbuntu_20.04/amd64/libbroker${ZEEK_LTS}-dev_${ZEEK_VERSION}_amd64.deb \
    https://download.zeek.org/binary-packages/xUbuntu_20.04/amd64/zeek${ZEEK_LTS}-libcaf-dev_${ZEEK_VERSION}_amd64.deb \
 && [[ ${ZEEK_VERSION} = 4.* ]] && curl -f -L --remote-name-all \
    https://download.zeek.org/binary-packages/xUbuntu_20.04/amd64/zeek${ZEEK_LTS}-btest_${ZEEK_VERSION}_amd64.deb \
 || pip3 install --no-cache-dir "btest>=0.66" zkg \
 && dpkg -i ./*.deb \
 && cd - \
 && rm -rf /tmp/zeek-packages \
 # Need a newer zkg than the one currently packaged with Zeek.
 && pip3 install --no-cache-dir "zkg>=2.12.0" \
 # Spicy build and test dependencies.
 && apt-get install -y --no-install-recommends git ninja-build ccache bison flex g++ libfl-dev python3 python3-pip zlib1g-dev jq locales-all python3-setuptools python3-wheel make \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 # Install a recent CMake.
 && mkdir -p /opt/cmake \
 && curl -f -L https://github.com/Kitware/CMake/releases/download/v3.18.0/cmake-3.18.0-Linux-x86_64.tar.gz | tar xzvf - -C /opt/cmake --strip-components 1 \
 # Configure zkg \
 && zkg autoconfig \
 && echo "@load packages" >>"$(zeek-config --site_dir)"/local.zeek
ENV PATH="/opt/zeek/bin:/opt/cmake/bin:${PATH}"

# Install Spicy.
ADD . /opt/spicy/src
RUN cd /opt/spicy/src \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --generator=Ninja --prefix=/opt/spicy \
 && ninja -C build install \
 && rm -rf build
ENV PATH="/opt/spicy/bin:/opt/zeek/bin:${PATH}"

# Install Spicy Zeek plugin and analyzers.
RUN echo Y | zkg -vvv install spicy-plugin
RUN echo Y | zkg -vvv install spicy-analyzers

WORKDIR /root
