FROM continuumio/anaconda3:4.1.1
MAINTAINER "Greg Way" <gregway@mail.med.upenn.edu>

# Install base packages
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libssh2-1-dev \
    vim && rm -rf /var/lib/apt/lists/*;

###########################
# Clone nf1_inactivation Repo
###########################
# ARG CACHEBUST=1
RUN git clone https://github.com/greenelab/nf1_inactivation.git

###########################
# Install R
###########################
RUN apt-get install --no-install-recommends -y \
    r-base \
    r-base-dev \
    r-cran-rcpp && rm -rf /var/lib/apt/lists/*;

RUN echo "deb http://cran.irsn.fr/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keys.gnupg.net --recv-key 381BA480
RUN apt-get update && apt-get install --no-install-recommends -y r-base && rm -rf /var/lib/apt/lists/*;

RUN mkdir /root/.checkpoint
