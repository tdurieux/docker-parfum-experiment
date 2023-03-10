# inherit the baidu sdk image
FROM baiduxlab/sgx-rust:1.0.0

MAINTAINER enigmampc

WORKDIR /root

RUN rm -rf /root/sgx

# clone the rust-sgx-sdk baidu sdk v1.0.0

RUN git clone https://github.com/baidu/rust-sgx-sdk.git sgx -b v1.0.0

# dependency for https://github.com/erickt/rust-zmq