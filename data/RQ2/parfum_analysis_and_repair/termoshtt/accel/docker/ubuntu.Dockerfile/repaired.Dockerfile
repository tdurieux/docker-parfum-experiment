FROM nvidia/cuda:CUDA_VERSION-base-ubuntuUBUNTU_VERSION

COPY cuda.conf /etc/ld.so.conf.d
RUN ldconfig
ENV LIBRARY_PATH /usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs

RUN apt-get update \
 && apt-get install --no-install-recommends -y curl gcc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.42.0
ENV PATH /root/.cargo/bin:$PATH

RUN cargo install ptx-linker
RUN rustup toolchain add nightly-NIGHTLY_VERSION
RUN rustup target add nvptx64-nvidia-cuda --toolchain nightly-NIGHTLY_VERSION

RUN rustup component add rustfmt clippy
