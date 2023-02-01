FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y python python-dev python-pip python-numpy wget zip python-biopython mercurial && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir boto3 cloudpickle awscli

RUN pip install --no-cache-dir anadama2

RUN hg clone https://biobakery@bitbucket.org/biobakery/metaphlan2 && \
    cd metaphlan2 && \
    hg update '2.7.7' && \
    cp *.py /usr/local/bin/ && \
    cp utils/*.py /usr/local/bin/ && \
    cd ../ && \
    rm -r metaphlan2

RUN pip install --no-cache-dir biom-format

# Install bowtie2
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.3/bowtie2-2.2.3-linux-x86_64.zip && \
    unzip bowtie2-2.2.3-linux-x86_64.zip && \
    mv bowtie2-2.2.3/bowtie2* /usr/local/bin/ && \
    rm bowtie2-2.2.3-linux-x86_64.zip

# Install metaphlan2 databases
RUN metaphlan2.py --install

WORKDIR /tmp

