#ANACONDA
#FROM continuumio/miniconda3

#PIP
FROM python:3.8-slim
# install the notebook package
RUN pip install --no-cache-dir --no-cache --upgrade pip && \
    pip install --no-cache-dir --no-cache notebook





USER root
#ANACONDA
#RUN conda create -n jetset-env python=3.7
#ENV PATH /opt/conda/envs/jetset-env/bin:$PATH
#RUN echo "source activate jetset-env" > ~/.bashrc


ADD requirements_docker.txt /requirements_docker.txt


#PIPI
RUN pip install --no-cache-dir -r requirements_docker.txt
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y swig && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir git+http://github.com/andreatramacere/jetset#egg=jetset


# create user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

ADD notebooks $HOME/notebooks


RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}/notebooks
CMD cd ${HOME}/notebooks
CMD ls
