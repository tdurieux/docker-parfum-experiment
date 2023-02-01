FROM debian:11
# FROM fedora:35

RUN apt update -qqy && apt install --no-install-recommends -qqy build-essential autoconf cmake git zlib1g-dev libbz2-dev liblzma-dev samtools bcftools && rm -rf /var/lib/apt/lists/*;
RUN apt clean ; apt autoclean

# RUN dnf install gcc gcc-c++ make automake autoconf cmake git libstdc++-static zlib-devel bzip2-devel xz-devel samtools bcftools

RUN git clone https://github.com/Parsoa/SVDSS.git

RUN cd SVDSS ; mkdir build ; cd build ; cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cd SVDSS ; mkdir build ; cd build ; make

COPY run-svdss.sh /
COPY input /
RUN bash run-svdss.sh /SVDSS/SVDSS 22.fa 22.bam output