FROM rustlang/rust:nightly-stretch
RUN set -x \
    && curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh \
    && apt update \
    && apt install --no-install-recommends -y lsb-release wget software-properties-common apt-transport-https \
    && bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" \
    && ln -s /usr/bin/clang-11 /usr/bin/clang && rm -rf /var/lib/apt/lists/*;
CMD ["bash", "-c"]
