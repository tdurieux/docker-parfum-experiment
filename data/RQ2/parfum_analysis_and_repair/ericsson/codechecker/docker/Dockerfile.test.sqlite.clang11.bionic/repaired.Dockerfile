FROM ubuntu:18.04

RUN apt-get update \
  && apt-get install --no-install-recommends -y software-properties-common wget \
  && wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
  && add-apt-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-11 main" \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
       clang-11 \
       clang-tidy-11 \
       libpq-dev \
       make \
       build-essential \
       curl \
       gcc-multilib \
       git \
       python3-virtualenv \
       python3-dev \
       python3-pip \
       python3-setuptools \
       libsasl2-dev \
       python-dev \
       libldap2-dev \
       libssl-dev \
  && pip3 install --no-cache-dir wheel \
  && pip3 install --no-cache-dir virtualenv \
  && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 9999 \
  && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 9999 \
  && update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-11 9999 && rm -rf /var/lib/apt/lists/*;

COPY . /codechecker

WORKDIR "/codechecker"

RUN chmod a+x /codechecker/docker/entrypoint.sh

ENTRYPOINT ["/codechecker/docker/entrypoint.sh"]
