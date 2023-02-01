FROM tensorflow/tensorflow:1.13.1-gpu-py3

RUN apt update && apt install --no-install-recommends -y cmake wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://dl.google.com/go/go1.13.linux-amd64.tar.gz && \
    tar -C /usr/local -xf go1.13.linux-amd64.tar.gz && \
    rm go1.13.linux-amd64.tar.gz
ENV PATH=${PATH}:/usr/local/go/bin

ADD . /src/kungfu
WORKDIR /src/kungfu

RUN ldconfig /usr/local/cuda-10.0/targets/x86_64-linux/lib/stubs && pip3 install --no-cache-dir --no-index -U .
RUN GOBIN=/usr/bin go install -v ./srcs/go/cmd/kungfu-run
