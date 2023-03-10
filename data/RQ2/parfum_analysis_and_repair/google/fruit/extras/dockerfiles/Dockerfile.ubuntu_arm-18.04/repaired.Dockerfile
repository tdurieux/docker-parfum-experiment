FROM multiarch/ubuntu-core:arm64-bionic
MAINTAINER Marco Poletti <poletti.marco@gmail.com>

COPY common_install.sh common_cleanup.sh /

RUN bash -x /common_install.sh
RUN apt-get install -y --allow-unauthenticated --no-install-recommends \
    g++-8 \
    g++-7 \
    g++-5 \
    clang-3.9 \
    clang-4.0 \
    clang-5.0 \
    clang-6.0 \
    python \
    python3-sh \
    python3-typed-ast \
    clang-tidy \
    clang-format && rm -rf /var/lib/apt/lists/*;
RUN bash -x /common_cleanup.sh
