FROM ubuntu
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y git cmake g++ \
    libboost-test-dev libboost-program-options-dev libboost-serialization-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/ddemidov/amgcl
RUN cmake -Bamgcl-build -DAMGCL_BUILD_EXAMPLES=ON -DCMAKE_BUILD_TYPE=Release amgcl && \
    cmake --build amgcl-build -j 4
ENV PATH="${PATH}:/amgcl-build/examples"
WORKDIR /data
