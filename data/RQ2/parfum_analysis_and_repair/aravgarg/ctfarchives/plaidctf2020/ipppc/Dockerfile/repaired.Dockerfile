FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
 bison \
 build-essential \
 flex \
 git \
 libnl-route-3-dev \
 libprotobuf-dev \
 pkg-config \
 protobuf-compiler \
 python && rm -rf /var/lib/apt/lists/*;

WORKDIR /workdir
RUN git clone https://github.com/google/nsjail.git && \
 cd nsjail && \
 git checkout 2.8 && \
 make

ADD hashcash.py .
ADD server.py .
ADD connman .
ADD jail jail
ADD flag .

EXPOSE 9669
CMD ["./server.py"]
