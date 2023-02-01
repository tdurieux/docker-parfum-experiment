################################
## Draft Dockerfile to ChIA-PIPE
#
# Step 1. Install ChIA-PET Utilities (CPU)
# Step 2. Install other dependencies
# Step 3. Copy over shell scripts
#
# 28 Feb 2019 
##################################

# Set the base image to CentOS6
FROM centos:6.6

# File Author / Maintainer
MAINTAINER Daniel Capurso

## Dependencies
# zlib v 1.2.8
# ChiaSigScaled v 19.4.17n
# git
# bwa       (Compiled during CPU make ??)
# BWT-SW    (Compiled during CPU make ??)


# Update the repository sources list
# Install base packages: git, python, wget, unzip, R
RUN yum -y update && yum -y install \
    git \
    curl \
    tar \
    unzip \
    make \
    automake \
    gcc \
    gcc-c++ \
    kernel-devel

### Install ChIA-PET Utilities (CPU)

## Make outer working directory
RUN mkdir cpu-dir

## Download and compile zlib (v 1.2.8)
RUN cd cpu-dir && curl -O https://www.zlib.net/fossils/zlib-1.2.8.tar.gz
RUN cd cpu-dir && tar -xzvf zlib-1.2.8.tar.gz
RUN cd cpu-dir/zlib-1.2.8 && ./configure && make 

## Download and compile Chiasig
RUN cd cpu-dir && curl -O http://folk.uio.no/jonaspau/chiasig/ChiaSigCPPv093.zip
RUN cd cpu-dir && unzip ChiaSigCPPv093.zip
RUN cd cpu-dir/ChiaSigCPPv093 && make

## Compile CPU
COPY /Users/capurd/proj/chia_pet/chia_pet_tool_2/cpu-dir/cpu-dir cpu-dir/cpu-dir
RUN cd cpu-dir && make


#### Install other dependencies

## Install Anaconda2
wget https://repo.anaconda.com/archive/Anaconda2-5.2.0-Linux-x86_64.sh
bash Anaconda2-5.2.0-Linux-x86_64.sh -b -p ${install_dir}/anaconda2
ln -s anaconda2/bin/python python
ln -s anaconda2/bin/conda conda


## Install pysam (Python package, not included with conda)
./conda install -c anaconda pysam

## Install biopython (Python package)
./conda install -c anaconda biopython

## Install regex (Python package)
./conda install -c anaconda regex

## Install MACS peak caller
./conda install -c bioconda macs2
ln -s anaconda2/bin/macs2 macs2


## Install pigz
wget http://zlib.net/pigz/pigz-2.4.tar.gz
tar -xzvf pigz-2.4.tar.gz
cd pigz-2.4
make
cp pigz unpigz ../
cd ../
rm -r pigz-2.4


## Install java/1.8
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" \
http://download.oracle.com/otn-pub/java/jdk/\
8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
#
tar -xzvf jdk-8u131-linux-x64.tar.gz
cp -r jdk1.8.0_131/jre/ .
yes | rm -r jdk1.8.0_131 
ln -s jre/bin/java java


## Install perl/5.26.0
wget http://www.cpan.org/src/5.0/perl-5.26.0.tar.gz
tar -xzvf perl-5.26.0.tar.gz
cd perl-5.26.0
./Configure -des -Dprefix=${install_dir}
make
make test
make install
cd ..
yes | rm -r perl-5.26.0


## Install bedtools/2.26.0
wget https://github.com/arq5x/bedtools2/releases/download/v2.26.0/\
bedtools-2.26.0.tar.gz
#
tar -xzvf bedtools-2.26.0.tar.gz
cd bedtools2
make
cd bin
cp * ../../
cd ../../
rm -r bedtools2


## Install samtools/1.5
wget https://sourceforge.net/projects/samtools/files/samtools/1.5/\
samtools-1.5.tar.bz2
#
tar -xvjf samtools-1.5.tar.bz2
cd samtools-1.5
./configure --disable-lzma
make
cp samtools ../
cd ../
rm -r samtools-1.5


## Install R/3.2.1
wget http://lib.stat.cmu.edu/R/CRAN/src/base/R-3/R-3.2.1.tar.gz
tar -xzvf R-3.2.1.tar.gz
cd R-3.2.1
./configure --prefix=${install_dir} --with-x=no
make
cd ../
ln -s R-3.2.1/bin/R R

