#Build with:
#sudo docker build -t davidebolo1993/visor .

FROM ubuntu:20.04

# File author/maintainer info
MAINTAINER Davide Bolognini <davidebolognini7@gmail.com>

# Install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y nano curl git build-essential g++ cmake libz-dev libcurl4-openssl-dev libssl-dev libbz2-dev liblzma-dev libncurses5-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN curl -f -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda
RUN conda create -y -n visorenv python=3.8
RUN echo "source activate visorenv" > ~/.bashrc
ENV PATH /miniconda/envs/visorenv/bin:$PATH
RUN conda install -y -n visorenv -c bioconda bedtools
RUN conda install -y -n visorenv -c r r-base
#RUN conda install -y -n visorenv -c bioconda bioconductor-biocinstaller bioconductor-regioner r-optparse
#get htslib
RUN curl -f -LO https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2 && tar -vxjf htslib-1.11.tar.bz2 && cd htslib-1.11 && make && make install && rm htslib-1.11.tar.bz2
#get samtools
RUN curl -f -LO https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 && tar -vxjf samtools-1.11.tar.bz2 && cd samtools-1.11 && make && make install && rm samtools-1.11.tar.bz2
#get minimap2
RUN curl -f -L https://github.com/lh3/minimap2/releases/download/v2.17/minimap2-2.17_x64-linux.tar.bz2 | tar -jxvf -
ENV PATH="${PATH}:/minimap2-2.17_x64-linux"
#get VISOR and the required python dependencies
RUN git clone https://github.com/davidebolo1993/VISOR.git && cd VISOR && pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir --upgrade cython && python setup.py install

#Pull with:
#sudo docker pull davidebolo1993/visor

#Then run:
#sudo docker run davidebolo1993/visor VISOR --help

#Or load the environment
#sudo docker run -ti davidebolo1993/visor
#$(visorenv) VISOR --help
