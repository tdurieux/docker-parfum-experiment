FROM continuumio/miniconda3

RUN apt-get update && apt-get install --no-install-recommends -y \
  libxdamage-dev \
  libxcomposite-dev \
  libxcursor1 \
  libxfixes3 \
  libgconf-2-4 \
  libxi6 \
  libxrandr-dev \
  libxinerama-dev \
  pv \
  gcc && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends --reinstall build-essential -y && rm -rf /var/lib/apt/lists/*;


RUN git clone https://github.com/usc-isi-i2/kgtk/

RUN cd /kgtk && python setup.py install

RUN conda update -n base -c defaults conda

RUN conda install -c conda-forge graph-tool

RUN conda install -c conda-forge jupyterlab

RUN pip install --no-cache-dir chardet

RUN pip install --no-cache-dir gensim

RUN pip install --no-cache-dir papermill

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
RUN chown -R ${NB_UID} kgtk
USER ${NB_USER}
