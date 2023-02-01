FROM jupyter/scipy-notebook:2022-01-12

MAINTAINER Robert Gieseke <rob.g@web.de>

USER root

RUN apt-get update && \
    apt-get install -y libboost-filesystem-dev libboost-system-dev --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pyhector

COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
