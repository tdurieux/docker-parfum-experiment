FROM golang:1.16

RUN apt-get update && apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L -O https://github.com/wasmerio/wasmer/releases/download/2.2.1/wasmer-linux-amd64.tar.gz
RUN tar zvxf wasmer-linux-amd64.tar.gz && rm wasmer-linux-amd64.tar.gz
RUN cp lib/libwasmer.so /usr/lib/libwasmer.so
