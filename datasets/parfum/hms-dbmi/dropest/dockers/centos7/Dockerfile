FROM library/centos:7.4.1708
MAINTAINER Viktor Petukhov "viktor.s.petuhov@ya.ru"

RUN \
  yum -y install epel-release && \
  yum -y install \
    bzip2-devel \
    cmake \
    cmake3 \
    git \
    libcurl-devel \
    openssl-devel \
    R \
    vim \
    wget

RUN \
  cd /root && \
  wget https://github.com/jgm/pandoc/releases/download/2.1.3/pandoc-2.1.3-linux.tar.gz && \
  tar xvzf pandoc-2.1.3-linux.tar.gz --strip-components 1 -C /usr/local/ && \
  git clone git://github.com/pezmaster31/bamtools.git && \
  mkdir bamtools/build && \
  cd bamtools/build && \
  cmake3 .. && make && make install

RUN useradd -m user
USER user

ENTRYPOINT ["/bin/bash"]
WORKDIR /home/user

RUN \
  mkdir ~/local && \
  wget http://sourceforge.net/projects/boost/files/boost/1.60.0/boost_1_60_0.tar.gz && \
  tar -xvzf boost_1_60_0.tar.gz && \
  cd boost_1_60_0 && \
  ./bootstrap.sh --with-libraries=filesystem,iostreams,log,system,thread,test && \
  ./b2 cxxflags=-std=c++11 link=shared threading=multi install --prefix=/home/user/local

RUN \
  cd && \
  git clone https://github.com/hms-dbmi/dropEst.git && \
  R -e 'dir.create(Sys.getenv("R_LIBS_USER"), recursive=T)' && \
  R -e 'chooseCRANmirror(ind=52); install.packages(c("devtools", "RcppProgress", "Rcpp","RcppEigen", "RInside", "Matrix", "optparse", "rmarkdown"))' && \
  R -e 'devtools::install_local("~/dropEst/dropestr/", dependencies=T)' && \
  R -e 'chooseCRANmirror(ind=52); install.packages("ks", dependencies=c("Depends", "Imports", "LinkingTo"))'

RUN \
  mkdir dropEst/build && \
  cd dropEst/build && \
  cmake -D BOOST_ROOT=~/local/ .. && \
  make

ENV PATH=/home/user/dropEst/build:$PATH
