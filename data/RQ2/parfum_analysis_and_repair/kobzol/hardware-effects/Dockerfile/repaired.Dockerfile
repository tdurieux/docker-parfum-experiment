FROM ubuntu:bionic

RUN apt-get update && apt-get install -y --no-install-recommends build-essential cmake python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /hardware-effects
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .
RUN mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j
