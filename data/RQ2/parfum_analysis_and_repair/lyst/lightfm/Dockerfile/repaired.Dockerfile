FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y libxml2 libxslt-dev wget bzip2 gcc && rm -rf /var/lib/apt/lists/*;

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda install pytest jupyter scikit-learn

ENV PYTHONDONTWRITEBYTECODE 1

ADD . /home/lightfm/
WORKDIR /home/

RUN cd lightfm && pip install --no-cache-dir -e .
