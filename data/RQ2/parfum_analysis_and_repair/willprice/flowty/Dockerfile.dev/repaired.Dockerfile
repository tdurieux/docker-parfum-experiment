FROM willprice/opencv4:cuda-10.1-cudnn7-debug
LABEL maintainer="will.price94+docker@gmail.com"

RUN apt-get update && \
    apt-get install --no-install-recommends -y valgrind g++ python3 python3-dbg python3-pip wget vim && \
    rm -rf /var/lib/apt/lists/*
RUN python3dm -m pip install Cython numpy pytest
RUN mkdir /app

WORKDIR /app
ENTRYPOINT ["bash"]