FROM ubuntu:16.04

RUN apt-get update && apt-get -y --no-install-recommends install build-essential libgsl0-dev libboost-dev zlib1g-dev git lsb-release libopenblas-dev && rm -rf /var/lib/apt/lists/*;

RUN cd /opt && git clone https://github.com/lipsia-fmri/lipsia.git && \ 
    cd lipsia && bash -c "source lipsia-setup.sh && cd src && make"

ENV PATH=/opt/lipsia/bin:$PATH \
    LD_LIBRARY_PATH=/opt/lipsia/lib:$LD_LIBRARY_PATH
