FROM ubuntu:18.04

# also install python version 2 used by bowtie2
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir boto3 cloudpickle awscli

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/' && \
    apt-get update -y && DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install r-base libcurl4-openssl-dev -y && rm -rf /var/lib/apt/lists/*;

RUN R -q -e "install.packages('XICOR', repos='http://cran.r-project.org')" && \
R -q -e "install.packages('eva', repos='http://cran.r-project.org')"

RUN pip3 install --no-cache-dir scipy
RUN pip3 install --no-cache-dir Cython
RUN pip3 install --no-cache-dir anadama2
RUN pip3 install --no-cache-dir jinja2
RUN pip3 install --no-cache-dir threadpoolctl
RUN pip3 install --no-cache-dir patsy
RUN pip3 install --no-cache-dir halla==0.8.20
