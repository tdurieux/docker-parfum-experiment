FROM ubuntu:bionic
RUN apt-get update && \
   apt-get -y --no-install-recommends install python2.7 python-pip libboost1.62-all-dev \
   libeigen3-dev git gnupg2 sudo wget ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN echo 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' \
   > /etc/apt/sources.list.d/cran.list
RUN apt-key adv --keyserver keyserver.ubuntu.com \
   --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN ln -fs /usr/share/zoneinfo/Australia/Melbourne /etc/localtime && \
   dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get install --no-install-recommends -y r-base r-base-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN useradd -m flashpca-user
RUN chpasswd flashpca-user:password
WORKDIR /home/flashpca-user
USER flashpca-user
RUN wget https://github.com/yixuan/spectra/archive/v0.8.1.tar.gz && \
   tar xvf v0.8.1.tar.gz && rm v0.8.1.tar.gz
ADD https://api.github.com/repos/gabraham/flashpca/git/refs/heads/master \
   version.json
RUN git clone https://github.com/gabraham/flashpca.git
RUN cd flashpca && \
   make all \
   EIGEN_INC=/usr/include/eigen3 \
   BOOST_INC=/usr/include/boost \
   SPECTRA_INC=$HOME/spectra-0.8.1/include &&\
   make flashpca_x86-64 \
   EIGEN_INC=/usr/include/eigen3 \
   BOOST_INC=/usr/include/boost \
   SPECTRA_INC=$HOME/spectra-0.8.1/include
#RUN R -e "install.packages(c('abind', 'RcppEigen', 'BH', 'RSpectra'))"


