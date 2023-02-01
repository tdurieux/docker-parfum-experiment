FROM nvidia/cuda:10.1-runtime
ENV LANG=C.UTF-8
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-pip python3-wheel libgomp1 \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install setuptools
ARG version
RUN pip3 install bminf==$version -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir 
ADD examples examples
ADD benchmark benchmark
