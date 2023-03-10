ARG GO_VERSION=1.15.6

FROM golang:${GO_VERSION}-buster

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates llvm clang mesa-opencl-icd ocl-icd-opencl-dev jq gcc git pkg-config bzr libhwloc-dev && rm -rf /var/lib/apt/lists/*;

ARG FILECOIN_FFI_COMMIT=62f89f108a6a8fe9ad6ed52fb7ffbf8594d7ae5c
ARG FFI_DIR=/extern/filecoin-ffi

RUN mkdir -p ${FFI_DIR} \
    && git clone https://github.com/filecoin-project/filecoin-ffi.git ${FFI_DIR} \
    && cd ${FFI_DIR} \
    && git checkout ${FILECOIN_FFI_COMMIT} \
    && make

RUN ldconfig
