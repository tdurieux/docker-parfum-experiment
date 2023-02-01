FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu14.04

LABEL maintainer="team@gnes.ai"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && rm -rf /var/lib/apt/lists/*;

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda2-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
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

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && \
    /opt/conda/bin/conda install faiss-gpu cudatoolkit=10.0 -c pytorch && \
    /opt/conda/bin/pip install git+https://github.com/gnes-ai/gnes.git --no-cache-dir --compile && \
    rm -rf /var/lib/apt/lists/*

ADD *.yml ./

ENTRYPOINT ["/opt/conda/bin/gnes", "index", "--yaml_path", "faiss.yml"]