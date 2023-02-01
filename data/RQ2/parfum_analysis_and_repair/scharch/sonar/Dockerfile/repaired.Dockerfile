########################################################
# Dockerfile for automated build of latest SONAR code  #
#                                                      #
# Please see https://github.com/scharch/SONAR for more #
#  information.                                        #
########################################################

FROM ubuntu:bionic
MAINTAINER Chaim Schramm chaim.schramm@nih.gov

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /

#install Python
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
  build-essential \
  zlib1g-dev \
  libncurses5-dev \
  libgdbm-dev \
  libnss3-dev \
  libssl-dev \
  libreadline-dev \
  libffi-dev \
  wget \
  python3 \
  python3-pip && rm -rf /var/lib/apt/lists/*;

#get biopython
RUN pip3 install --no-cache-dir "biopython==1.73"

#add docopt
RUN pip3 install --no-cache-dir docopt

#add fuzzywuzzy for master script
RUN pip3 install --no-cache-dir fuzzywuzzy

#install libraries for bioperl
RUN apt-get install --no-install-recommends -y \
  gcc-multilib \
  perl \
  cpanminus \
  liblwp-protocol-https-perl \
  libnet-https-any-perl \
  libdb-dev \
  graphviz \
  make \
  libexpat1-dev \
  libatlas-base-dev \
  gfortran && rm -rf /var/lib/apt/lists/*;

#install perl modules that are prerequisites
RUN cpanm \
  CPAN::Meta \
  YAML \
  Digest::SHA \
  Module::Build \
  Test::Most \
  Test::Weaken \
  Test::Memory::Cycle \
  Clone \
  HTML::TableExtract \
  Algorithm::Munkres \
  Algorithm::Combinatorics \
  Statistics::Basic \
  List::Util \
  PDL::LinearAlgebra::Trans \
  Array::Compare \
  Convert::Binary::C \
  Error \
  Graph@0.9711 \
  GraphViz \
  Inline::C \
  PostScript::TextBlock \
  Set::Scalar \
  Sort::Naturally \
  Math::Random \
  Spreadsheet::ParseExcel \
  IO::String \
  JSON \
  Data::Stag \
  CGI \
  Bio::Phylo \
  Switch

#now actually install BioPerl
RUN cpanm -v \
    https://github.com/bioperl/bioperl-live/archive/release-1-7-2.tar.gz

#install PyQt and ete3
RUN apt-get install --no-install-recommends -y \
    python3-pyqt4 python3-pyqt4.qtopengl python-lxml python-six && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade ete3

#install AIRR reference library
RUN pip3 install --no-cache-dir airr

#install Levensthein
RUN pip3 install --no-cache-dir python-Levenshtein

#install R
RUN echo "deb http://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" >> /etc/apt/sources.list
RUN gpg --batch --keyserver keyserver.ubuntu.com --recv-key 51716619E084DAB9
RUN gpg --batch -a --export 51716619E084DAB9 | apt-key add -
RUN apt-get update && apt-get install --no-install-recommends -y r-base r-base-dev && rm -rf /var/lib/apt/lists/*;

#install R packages
RUN R --vanilla -e 'install.packages(c("docopt","MASS","ggplot2","ptinpoly"), repos="http://cran.r-project.org/")'

#install Xvfb for 4.4
RUN apt-get install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;

#get fastq-dump for vignette
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -O https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.9.6-1/sratoolkit.2.9.6-1-ubuntu64.tar.gz
RUN tar -xzf sratoolkit.2.9.6-1-ubuntu64.tar.gz && rm sratoolkit.2.9.6-1-ubuntu64.tar.gz
RUN ln -s /sratoolkit.2.9.6-1-ubuntu64/bin/fastq-dump /usr/bin/fastq-dump

#pull latest SONAR source code and set it up
RUN apt-get install --no-install-recommends -y git libidn11 && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/scharch/SONAR.git
WORKDIR SONAR
RUN echo | ./setup.py
RUN cp sonar /usr/bin

WORKDIR /
