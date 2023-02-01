FROM gcc:8

RUN apt-get update && apt-get install --no-install-recommends -y git cmake libcap-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/EIPStackGroup/OpENer.git --depth=1
WORKDIR /OpENer/bin/posix
RUN sh setup_posix.sh
RUN make -j4