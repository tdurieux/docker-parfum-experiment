# tell docker which basic image my new image is based on
FROM centos:7

WORKDIR /tmp

COPY requirements.txt /tmp

# install packages
RUN yum -y install epel-release \ 
    && yum -y install python-pip python-devel git \
	&& yum -y install tkinter wget gcc g++ gcc-gfortran\
	&& yum -y update \
	&& yum -y clean all && rm -rf /var/cache/yum

# install Python requirements
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir numpy \
    && pip install --no-cache-dir pytest \
    && pip install --no-cache-dir -r requirements.txt \
    && rm -rf ~/.cache ~/.pip

