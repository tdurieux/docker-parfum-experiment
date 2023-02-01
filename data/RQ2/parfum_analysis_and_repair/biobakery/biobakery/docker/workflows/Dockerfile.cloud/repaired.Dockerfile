FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python python-dev python-pip apt-transport-https openjdk-8-jre wget zip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir boto3 cloudpickle awscli

RUN pip install --no-cache-dir anadama2==0.7.9

# install kneaddata and dependencies	
RUN pip install --no-cache-dir biobakery-workflows==0.14.2 && \
    pip install --no-cache-dir kneaddata && \
    pip install --no-cache-dir humann2

# install visualization dependencies	
RUN apt-get update -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python-numpy python-matplotlib \
        python-scipy pandoc texlive software-properties-common \
        python-pandas python-biopython && \
    apt-get remove -y texlive-fonts-recommended-doc texlive-latex-base-doc \	
        texlive-latex-recommended-doc \	
        texlive-pictures-doc texlive-pstricks-doc && \
    pip install --no-cache-dir matplotlib==2.0.0 && rm -rf /var/lib/apt/lists/*;

# install R with vegan	
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \	
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \	
    apt-get update -y && \
    apt-get install --no-install-recommends r-base-dev libcurl4-openssl-dev -y && \
    R -q -e "install.packages('vegan', repos='http://cran.r-project.org')" && rm -rf /var/lib/apt/lists/*;

# install hclust2	
RUN wget https://raw.githubusercontent.com/SegataLab/hclust2/master/hclust2.py && \
    mv hclust2.py /usr/local/bin/ && \
    chmod +x /usr/local/bin/hclust2.py

# Update to newer pandoc version (to work with latest engine options in anadama2)
RUN wget https://github.com/jgm/pandoc/releases/download/2.10/pandoc-2.10-1-amd64.deb && \
    dpkg -i pandoc-2.10-1-amd64.deb && \
    rm pandoc-2.10-1-amd64.deb

WORKDIR /tmp
