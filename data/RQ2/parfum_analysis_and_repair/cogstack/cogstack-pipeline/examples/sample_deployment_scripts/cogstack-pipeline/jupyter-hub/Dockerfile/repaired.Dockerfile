FROM jupyter/datascience-notebook:latest

USER root

ENV HTTP_PROXY=$HTTP_PROXY
ENV HTTPS_PROXY=$HTTPS_PROXY
ENV NO_PROXY=$NO_PROXY

# install R
RUN apt-get update --allow-unauthenticated && apt-get upgrade -y && \
    apt-get install -y --allow-unauthenticated --no-install-recommends \
    gnupg-agent \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    fonts-dejavu \
    build-essential \
    python3-dev \
    python3-pip \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gfortran \
    gcc \
    git \
    ssh \
    jq \
    htop \
    wget \
    curl \
    r-base && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir virtualenv pytesseract ipyparallel py7zr cython isort html2text jsoncsv simplejson detect wheel elasticsearch nltk keras bokeh seaborn matplotlib graphviz plotly tqdm && pip3 install --no-cache-dir medcat && pip install --no-cache-dir ipywidgets jupyter jupyterlab && pip install --no-cache-dir jupyterhub-nativea$
RUN pip3 install --no-cache-dir dvc jupyter_contrib_core jupyter_contrib_nbextensions jupyter-server-proxy tensorflow fastbook
RUN jupyter labextension install @jupyterlab/server-proxy