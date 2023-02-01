FROM ubuntu:20.04

# Environment needed to install cmake.
ENV TZ=US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y && apt-get install --no-install-recommends -y apt-utils \
    && apt-get install --no-install-recommends -y build-essential && apt-get install --no-install-recommends -y gcc && apt-get install --no-install-recommends -y automake && apt-get install --no-install-recommends -y autoconf \
    && apt-get install --no-install-recommends -y git && apt-get install --no-install-recommends -y cmake && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/aquynh/capstone/archive/4.0.2.tar.gz && tar xzf 4.0.2.tar.gz && cd capstone-4.0.2 && ./make.sh install && cd / && rm 4.0.2.tar.gz

RUN apt-get install --no-install-recommends -y python3 && apt-get install --no-install-recommends -y python3-dev && apt-get install --no-install-recommends -y python3-setuptools && apt-get install --no-install-recommends -y libz3-dev && apt-get install --no-install-recommends -y libboost-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/JonathanSalwan/Triton/archive/v0.8.1.tar.gz \
    && tar xzf v0.8.1.tar.gz \
    && cd Triton-0.8.1/ \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j2 install \
    && cd / && rm v0.8.1.tar.gz

# AFLplusplus checks git repo during make, so we need to clone instead of download a specific release.
RUN git clone https://github.com/AFLplusplus/AFLplusplus.git && cd AFLplusplus/ && git checkout 2.68c && make \
    && cd unicorn_mode && ./build_unicorn_support.sh && cd .. && make install && cd /

RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py

COPY requirements.txt efi_fuzz_requirements.txt
# uefi-firmware-parser in pypi is too old, let's use the one from github
RUN pip3 install --no-cache-dir git+https://github.com/theopolis/uefi-firmware-parser.git
RUN pip3 install --no-cache-dir -r efi_fuzz_requirements.txt
RUN pip3 install --no-cache-dir debugpy
