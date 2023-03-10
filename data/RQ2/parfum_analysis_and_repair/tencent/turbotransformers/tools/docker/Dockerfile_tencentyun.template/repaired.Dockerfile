FROM ccr.ccs.tencentyun.com/mmspr/turbo_transformers:0.1.1-dev
WORKDIR /workspace

ARG your_git.code.oa_name
ARG your_password

ENV http_proxy=http://devnet-proxy.oa.com:8080 \
    https_proxy=http://devnet-proxy.oa.com:8080 \
    no_proxy=git.code.oa.com

RUN git config --global credential.helper cache && \
    git clone --recursive http://${username}:${password}@git.code.oa.com/PRC_alg/fast_transformers && \
    cd /workspace/fast_transformers && \
    mkdir build && \
    cd build && \
    cmake .. -DWITH_GPU=OFF && \
    make -j 8 && \
    pip install --no-cache-dir ./turbo_transformers/python/pypackage/dist/turbo_transformers-0.0.0-cp37-cp37m-linux_x86_64.whl
