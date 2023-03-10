FROM nvidia/cuda:11.1.1-devel-ubuntu18.04

ENV DEBIAN_FRONTEND noninteractive

RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf
RUN echo "nameserver 8.8.4.4" >> /etc/resolv.conf

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-transport-https wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --batch --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ xenial main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null
RUN apt-get update
RUN apt install -y --no-install-recommends kitware-archive-keyring && rm -rf /var/lib/apt/lists/*;

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/overline-mining/olminer /usr/src/olminer

WORKDIR /usr/src/olminer
RUN git submodule update --init --recursive
RUN rm -rf ./build ; mkdir -p ./build && cd ./build && cmake -DOLHASHCUDA=ON -DCMAKE_BUILD_TYPE=Release -DHUNTER_JOBS_NUMBER=$(nproc) .. && make install

FROM nvidia/cuda:11.1.1-base-ubuntu18.04
RUN mkdir -p /home/bc
WORKDIR /home/bc
COPY --from=0 /usr/local/bin/olminer /home/bc
USER 1001
CMD ["sh", "-c", "/home/bc/olminer --${MINER_TYPE} -P ${STRATUM_URL}"]

