FROM ubuntu
ENV DEBIAN_FRONTEND noninteractive
RUN mkdir /MIDAS
WORKDIR /MIDAS

RUN apt update && apt install --no-install-recommends build-essential cmake python3-pip -yq && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/python3 /usr/bin/python

COPY CMakeLists.txt ./
COPY example ./example
COPY src ./src
COPY util ./util

RUN pip3 install --no-cache-dir pandas scikit-learn
RUN cmake -DCMAKE_BUILD_TYPE=Release -S . -B build/release
RUN cmake --build build/release --target Demo

ENTRYPOINT ["build/release/Demo"]
