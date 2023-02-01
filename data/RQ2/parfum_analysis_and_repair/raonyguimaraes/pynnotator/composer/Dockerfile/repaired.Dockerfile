############################################################
# Dockerfile to build Pynnotator
# Based on Ubuntu LTS
############################################################

# Set the base image to Ubuntu
FROM ubuntu:bionic

# File Author / Maintainer
MAINTAINER Raony Guimaraes

# Update the repository sources list

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get install --no-install-recommends -y apt-utils && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y make software-properties-common python3 python3-dev python3-pip libcurl4-openssl-dev sed python3-setuptools vcftools bcftools tabix zlib1g-dev liblzma-dev libpq-dev libbz2-dev build-essential zlib1g-dev liblocal-lib-perl cpanminus curl unzip wget pkg-config cython3 python-pysam sudo && \
    apt-get install --no-install-recommends -y libclass-dbi-mysql-perl libfile-copy-recursive-perl libarchive-extract-perl libarchive-zip-perl libwww-perl libcrypt-ssleay-perl libbio-perl-perl libcgi-pm-perl && \
	add-apt-repository ppa:webupd8team/java -y && \
	apt-get update && \
	sudo apt install --no-install-recommends -y openjdk-8-jdk && \
	apt-get clean && rm -rf /var/lib/apt/lists/*;
#RUN	cpanm DBI File::Copy::Recursive Archive::Extract Archive::Zip LWP::Simple Bio::Root::Version LWP::Protocol::https Bio::DB::Fasta CGI

################## BEGIN INSTALLATION ######################
# Create the default software directory

#RUN git clone http://github.com/raonyguimaraes/pynnotator

COPY . /pynnotator
WORKDIR /pynnotator
#VOLUME ./pynnotator/data /pynnotator/pynnotator/data

RUN python3 setup.py develop
VOLUME ./pynnotator/data /pynnotator/pynnotator/data

RUN pynnotator install
#ENTRYPOINT ["pynnotator"]
