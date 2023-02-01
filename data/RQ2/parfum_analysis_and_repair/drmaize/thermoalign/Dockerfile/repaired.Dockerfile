FROM ubuntu:latest

MAINTAINER Felix Francis <felixfrancier@gmail.com>

# Install all the softwares & dependencies required to run the pipeline
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*; # v 2.7.11+
#RUN apt-get install python-dev build-essential
RUN pip install --no-cache-dir --upgrade pip shutilwhich numpy pandas biopython
RUN pip install --no-cache-dir Cython# v 0.24
RUN pip install --no-cache-dir primer3-py# v 0.5.1
RUN pip install --no-cache-dir networkx# v 1.11

# Download and extract multiplx software
RUN wget --content-disposition https://bioinfo.ut.ee/download/dl.php?file=24
RUN tar xzf multiplx_linux_64_20101011.tar.gz && rm multiplx_linux_64_20101011.tar.gz
RUN rm -rf multiplx_linux_64_20101011.tar.gz

# Install BLASTn
RUN apt-get install --no-install-recommends -y ncbi-blast+ && rm -rf /var/lib/apt/lists/*;
RUN PATH=$PATH:~/opt/bin

# Download TA codes and sample genome, polymorphism vcf files
RUN git clone https://github.com/drmaize/ThermoAlign.git
RUN mv ThermoAlign/sample_genome/ ./
RUN mv ThermoAlign/sample_vcf/ ./
RUN mv ThermoAlign/TA_codes/ ./
RUN rm -rf ThermoAlign/
