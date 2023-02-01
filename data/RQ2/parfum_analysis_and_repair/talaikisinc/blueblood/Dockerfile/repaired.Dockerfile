FROM ubuntu:latest
MAINTAINER Tadas Talaikis
LABEL version="1.0"
LABEL description="Anaconda with additional wuantitative module for BlueBlood."

RUN apt-get clean
RUN apt-get update -q --fix-missing

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PYTHONIOENCODING UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get install --no-install-recommends -y wget \
    apt-utils \
    nano \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    git && rm -rf /var/lib/apt/lists/*;

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get install --no-install-recommends -y curl grep sed dpkg && \
    TINI_VERSION=$( curl -f https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:') && \
    curl -f -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get -qy autoremove

RUN conda install tensorflow -y
RUN conda install pymc3 -y
RUN conda install cython -y
RUN conda install lxml -y
RUN conda install scikit-learn -y
RUN conda install -c conda-forge fastparquet -y
RUN pip install --no-cache-dir -r requirements.txt
RUN python -m nltk.downloader all

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
