FROM ubuntu:15.04

#RUN echo "deb ftp://mirror.hetzner.de/ubuntu/packages precise main restricted universe multiverse" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# basic tools
RUN apt-get install --no-install-recommends -y openssh-server git-core curl wget vim-tiny build-essential python3-dev python3-setuptools && rm -rf /var/lib/apt/lists/*;

# compilers
RUN apt-get install --no-install-recommends -y gfortran build-essential make gcc build-essential && rm -rf /var/lib/apt/lists/*;

# install python
RUN apt-get install --no-install-recommends -y python3.4 python3.4-dev python3-pip && rm -rf /var/lib/apt/lists/*;

# python-PIL
RUN apt-get install --no-install-recommends -y python3-pil && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-httplib2 ipython3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-numpy python3-scipy python3-pip python3-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libatlas-dev libatlas3gf-base && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-skimage python3-matplotlib python3-pandas && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-h5py && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-opencv && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir scikit-learn

EXPOSE 8888
