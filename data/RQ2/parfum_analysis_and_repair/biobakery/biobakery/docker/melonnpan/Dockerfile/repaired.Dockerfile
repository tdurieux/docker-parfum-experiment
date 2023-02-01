FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python python-dev python3 python3-dev python3-pip apt-transport-https software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir boto3 cloudpickle awscli

RUN pip3 install --no-cache-dir anadama2

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/' && \
    apt-get update -y && DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install r-base libcurl4-openssl-dev -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends libssl-dev libxml2-dev -y && rm -rf /var/lib/apt/lists/*;
RUN R -q -e "install.packages(c('devtools'), repos='http://cran.r-project.org')"
RUN R -q -e "library(devtools); devtools::install_version('GenABEL.data', version = '1.0.0', repos = 'http://cran.us.r-project.org')"
RUN R -q -e "library(devtools); devtools::install_version('GenABEL', version = '1.8-0', repos = 'http://cran.us.r-project.org')"
RUN R -q -e "library(devtools); devtools::install_github('biobakery/melonnpan')"

