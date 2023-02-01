FROM ubuntu:focal
WORKDIR /src
ADD . /src
ENV TZ=Australia/Melbourne
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install --no-install-recommends -y gfortran libblas-dev liblapack-dev git build-essential cmake && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/LLNL/sundials.git /sundials; \
    mkdir /sundials/build;\
    cd /sundials/build; \
    cmake -DLAPACK_ENABLE=ON ..; \
    make && make install

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

RUN apt-get install --no-install-recommends -y python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install /src

