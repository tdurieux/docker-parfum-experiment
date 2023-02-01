# docker build commands
ARG FROM_IMAGE=nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

FROM ${FROM_IMAGE}

RUN rm /etc/apt/sources.list.d/cuda.list

RUN apt update && apt install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;

# change tsinghua mirror
RUN echo \
"deb [trusted=yes] https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse\n\
deb [trusted=yes] https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse\n\
deb [trusted=yes] https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse\n\
deb [trusted=yes] https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse" > /etc/apt/sources.list

RUN apt update && apt install --no-install-recommends wget \
        python3 python3-dev python3-pip \
        g++ build-essential -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/jittor

ENV PYTHONIOENCODING utf8
ENV DEBIAN_FRONTEND noninteractive

# change tsinghua mirror
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

RUN pip3 install --no-cache-dir \
        numpy \
        tqdm \
        pillow \
        astunparse \
        notebook

RUN pip3 install --no-cache-dir matplotlib

RUN apt install --no-install-recommends openmpi-bin openmpi-common libopenmpi-dev -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir jittor --timeout 100 && python3 -m jittor.test.test_example

RUN pip3 uninstall jittor -y

COPY . .

RUN pip3 install --no-cache-dir . --timeout 100

RUN python3 -m jittor.test.test_example

CMD python3 -m jittor.notebook --allow-root --ip=0.0.0.0