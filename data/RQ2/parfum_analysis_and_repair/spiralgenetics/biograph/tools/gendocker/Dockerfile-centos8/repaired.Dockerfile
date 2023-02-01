FROM centos:8

# 'perl' needed for bwa.  htslib-tools, vcftools, and bwa are in the
# "EPEL" repository, which must be installed before their packages can
# be found.

RUN yum install -y \
        python3 python3-virtualenv \
        gcc bzip2-devel zlib-devel python3-devel make which perl && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y htslib-tools vcftools bwa && rm -rf /var/cache/yum

RUN adduser spiral
USER spiral
RUN virtualenv /home/spiral/venv -p python3
RUN . /home/spiral/venv/bin/activate && pip install --no-cache-dir --upgrade pip
