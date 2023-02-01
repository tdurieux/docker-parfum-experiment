FROM ubuntu:jammy
RUN apt-get update \
 && apt-get install --no-install-recommends -y ca-certificates curl \
 && adduser --system --home /work --disabled-login work && rm -rf /var/lib/apt/lists/*;
COPY krustlet-wasi /usr/local/bin/
WORKDIR /work
ADD home /work
ENV KUBECONFIG=/work/.krustlet/config/kubeconfig RUST_LOG="info,regalloc=warn,workflow_model=debug,cranelift_codegen=info,wasi_provider=debug"
VOLUME /work
ENTRYPOINT ["/usr/local/bin/krustlet-wasi"]

