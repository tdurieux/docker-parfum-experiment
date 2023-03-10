FROM  nvidia/cuda:10.2-devel-ubuntu18.04

RUN apt-get update && apt-get install --no-install-recommends curl cmake python3-pip -y && rm -rf /var/lib/apt/lists/*;
# Note, numpy 1.20rc was being attempted and failing... I don't need that...
RUN pip3 install --no-cache-dir 'numpy<1.20'

## Manually install later CMake
#RUN curl -o cmake-3.16.5.tar.gz https://github.com/Kitware/CMake/releases/download/v3.16.5/cmake-3.16.5.tar.gz \
#    && tar -zxvf cmake-3.16.5.tar.gz \
#    && cd cmake-3.16.5 \
#    && ./bootstrap \
#    && make install
