#
# Docker image for simuPOP

FROM    ubuntu:latest

MAINTAINER Bo Peng <bpeng@mdanderson.org>

RUN apt-get update && apt-get -y --no-install-recommends install swig gcc g++ build-essential bzip2 libbz2-dev libz-dev curl git && rm -rf /var/lib/apt/lists/*;

RUN curl -f -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN     bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN     rm Miniconda3-latest-Linux-x86_64.sh
ENV     PATH=/miniconda/bin:${PATH}
RUN     conda update -y conda

WORKDIR /home/bpeng
RUN     git clone http://github.com/BoPeng/simuPOP simuPOP
WORKDIR /home/bpeng/simuPOP
RUN     git pull
RUN     python setup.py install

ENV     HOME /home/bpeng
