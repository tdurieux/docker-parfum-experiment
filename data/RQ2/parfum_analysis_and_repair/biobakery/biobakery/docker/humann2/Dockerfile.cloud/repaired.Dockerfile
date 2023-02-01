FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python python-dev python-pip python-numpy wget zip python-biopython mercurial && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir boto3 cloudpickle awscli

RUN pip install --no-cache-dir anadama2

# install metaphlan2 dependency
RUN hg clone https://biobakery@bitbucket.org/biobakery/metaphlan2 && \
    cd metaphlan2 && \
    hg update '2.7.7' && \
    cp *.py /usr/local/bin/ && \
    cp utils/*.py /usr/local/bin/ && \
    cd ../ && \
    rm -r metaphlan2

RUN pip install --no-cache-dir biom-format

# install humann2 and dependencies
RUN pip install --no-cache-dir humann2==2.8.2 --no-binary :all:

# change default database locations
RUN humann2_config --update database_folders nucleotide /opt/humann2/chocophlan && \
    humann2_config --update database_folders protein /opt/humann2/uniref && \
    humann2_config --update database_folders utility_mapping /opt/humann2/utility_mapping

WORKDIR /tmp

