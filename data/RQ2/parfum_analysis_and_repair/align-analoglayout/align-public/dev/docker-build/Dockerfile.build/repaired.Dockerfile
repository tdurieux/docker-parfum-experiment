FROM ubuntu:18.04 as can_build

RUN apt-get update && apt-get install --no-install-recommends -yq curl g++ git vim build-essential cmake lcov libboost-container-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;

FROM can_build as with_googletest

RUN \
    cd opt && \
    git clone https://github.com/google/googletest.git && \
    cd googletest && \
    git checkout c9ccac7cb7345901884aabf5d1a786cfa6e2f397 && \
    cd googletest && \
    mkdir mybuild && \
    cd mybuild && \
    cmake .. && \
    make

FROM with_googletest as with_json

RUN \
    cd opt && \
    git clone https://github.com/nlohmann/json.git

FROM with_json as with_protobuf

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -yq libprotobuf-dev protobuf-compiler && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;
