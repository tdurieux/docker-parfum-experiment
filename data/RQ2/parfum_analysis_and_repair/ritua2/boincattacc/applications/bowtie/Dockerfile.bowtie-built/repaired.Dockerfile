##########################
# BOWTIE-BUILT
#
# Downloads and installs bowtie from source
# Designed for BOINC testing
##########################


FROM ubuntu:16.04



COPY bowtie-1.2.2-linux-x86_64.zip /build/bowtie-1.2.2-linux-x86_64.zip
COPY Mov_Res.py /Mov_Res.py

# Updates and adds all binaries to the path

RUN apt-get update -y && apt-get install --no-install-recommends curl wget unzip python python-pip -y && \
    pip install --no-cache-dir binaryornot && cd /build && unzip bowtie-1.2.2-linux-x86_64 && \
    for file  in $(find /build/bowtie-1.2.2-linux-x86_64 -maxdepth 1 -not -type d); do \
    cp $file /usr/local/bin; done && \
    mkdir -p /root/shared/results && rm -rf /var/lib/apt/lists/*;


WORKDIR /data
