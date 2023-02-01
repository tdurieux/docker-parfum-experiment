FROM ubuntu:16.04
ENV PATH="/usr/local/go/bin:$PATH"
WORKDIR /go/src/
RUN apt-get update && apt-get install --no-install-recommends -y wget git gcc && rm -rf /var/lib/apt/lists/*;
RUN wget -qO- https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz | tar -C /usr/local/ -xz
RUN git clone https://github.com/Intel-Corp/multus-cni
RUN cd multus-cni; bash ./build

FROM busybox
COPY --from=0 /go/src/multus-cni/bin/multus /root
