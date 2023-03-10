# Base image
FROM debian:testing

# Install the dependencies:
#  - of the website
#  - of SimGrid itself
RUN apt-get --allow-releaseinfo-change update && \
    apt install --no-install-recommends -y \
       bibclean emacs-nox org-mode elpa-ess elpa-htmlize wget unzip r-cran-ggplot2 r-cran-tidyr r-cran-dplyr libtext-bibtex-perl && \
    apt install --no-install-recommends -y \
       g++ gcc gfortran default-jdk pybind11-dev \
       git \
       valgrind \
       libboost-dev libboost-all-dev \
       libeigen3-dev \
       cmake \
       python3-pip \
       doxygen fig2dev \
       chrpath \
       libdw-dev libevent-dev libunwind8-dev \
       python3-sphinx python3-breathe python3-sphinx-rtd-theme && rm -rf /var/lib/apt/lists/*;

#        linkchecker \
