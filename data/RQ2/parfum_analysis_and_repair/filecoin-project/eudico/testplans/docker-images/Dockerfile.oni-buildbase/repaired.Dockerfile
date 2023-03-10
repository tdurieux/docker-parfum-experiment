ARG GO_VERSION=1.17.9

FROM golang:${GO_VERSION}-buster

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates llvm clang mesa-opencl-icd ocl-icd-opencl-dev jq gcc git pkg-config bzr libhwloc-dev && rm -rf /var/lib/apt/lists/*;

ARG FILECOIN_FFI_COMMIT=8b97bd8230b77bd32f4f27e4766a6d8a03b4e801
ARG FFI_DIR=/extern/filecoin-ffi

RUN mkdir -p ${FFI_DIR} \
    && git clone https://github.com/filecoin-project/filecoin-ffi.git ${FFI_DIR} \
    && cd ${FFI_DIR} \
    && git checkout ${FILECOIN_FFI_COMMIT} \
    && make

RUN ldconfig
