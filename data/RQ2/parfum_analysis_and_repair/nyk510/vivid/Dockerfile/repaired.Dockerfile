FROM ubuntu:16.04

LABEL maintainer="nyker510"
ARG JUPYTER_PASSWORD="dolphin"

RUN apt-get update --fix-missing && \
  apt-get install --no-install-recommends -y \
        wget \
        make \
        unzip \
        bzip2 \
        gcc \
        g++ --fix-missing && rm -rf /var/lib/apt/lists/*;

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8


ENV CONDA_DIR /opt/conda
ENV PATH ${CONDA_DIR}/bin:${PATH}
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.5.12-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p ${CONDA_DIR} && \
    rm ~/miniconda.sh

RUN pip install --no-cache-dir cmake --upgrade
RUN pip install --no-cache-dir -U certifi --ignore-installed

ADD . .

# install packages for test env
RUN python setup.py sdist && \
    pip install --no-cache-dir $(ls dist/*.tar.gz)[test]

EXPOSE 8888

WORKDIR /workspace

# jupyter の config ファイルの作成
RUN mkdir ~/.jupyter &&\
  echo "c.NotebookApp.open_browser = False\n\
c.NotebookApp.ip = '*'\n\
c.NotebookApp.token = '${JUPYTER_PASSWORD}'" | tee -a ${HOME}/.jupyter/jupyter_notebook_config.py


CMD [ "jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--allow-root"]