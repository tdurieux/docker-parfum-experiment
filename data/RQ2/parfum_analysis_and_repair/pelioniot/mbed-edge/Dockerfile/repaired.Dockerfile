FROM ubuntu:20.04

ARG developer_certificate=./config/mbed_cloud_dev_credentials.c
ARG update_certificate=./config/update_default_resources.c

WORKDIR /usr/src/app/mbed-edge

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && \
    apt-get install --no-install-recommends -y build-essential libc6-dev cmake python3.6 python3-pip python3-setuptools && \
    apt-get install --no-install-recommends -y vim python3-venv && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir manifest-tool

RUN mkdir -p build && \
    cd build  &&  \
    cmake -DDEVELOPER_MODE=ON -DFIRMWARE_UPDATE=ON .. && \
    make

CMD [ "./build/bin/edge-core", "--http-port", "8080", "--edge-pt-domain-socket", "/tmp/edge.sock" ]

EXPOSE 8080