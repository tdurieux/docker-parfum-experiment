# Container with clang-format 6. Used in the `dev/format_code.sh` script.

FROM ubuntu:20.04

RUN apt-get -q update \
 && apt-get -qy --no-install-recommends install \
  clang-format-6.0 \
  git \
  python3 \
  python3-pip \
  libxml-filter-sort-perl \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-6.0 50

RUN pip3 install --no-cache-dir cmakelang==0.6.13
