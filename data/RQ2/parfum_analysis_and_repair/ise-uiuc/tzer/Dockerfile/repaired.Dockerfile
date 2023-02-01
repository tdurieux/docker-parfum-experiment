FROM ubuntu:20.04

RUN apt update --allow-unauthenticated

RUN DEBIAN_FRONTEND="noninteractive" apt --no-install-recommends install -y libfuzzer-12-dev clang cmake git python3 && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ise-uiuc/tzer.git

RUN cd /tzer/tvm_cov_patch && bash ./build_tvm.sh

RUN mv /tzer/src/run_libfuzz.py /tzer/tvm_cov_patch/tvm-libfuzz/build

RUN cd /tzer && apt install --no-install-recommends -y python3-pip && python3 -m pip install -r requirements.txt && rm -rf /var/lib/apt/lists/*;

ENV TVM_HOME=/tzer/tvm_cov_patch/tvm

ENV TVM_NO_COV_HOME=/tzer/tvm_cov_patch/tvm-no-cov

ENV PYTHONPATH=/tzer/tvm_cov_patch/tvm/python
