FROM multiarch/ubuntu-core:arm64-focal
MAINTAINER Marco Poletti <poletti.marco@gmail.com>

COPY common_install.sh common_cleanup.sh /

RUN bash -x /common_install.sh
RUN apt-get install -y --allow-unauthenticated --no-install-recommends \
    g++-7 \
    g++-8 \
    g++-9 \
    g++-10 \
    clang-6.0 \
    clang-7 \
    clang-8 \
    clang-9 \
    clang-10 \
    python \
    python3-sh \
    python3-typed-ast \
    clang-tidy \
    clang-format && rm -rf /var/lib/apt/lists/*;
RUN bash -x /common_cleanup.sh
