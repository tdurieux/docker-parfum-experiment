FROM continuumio/miniconda
MAINTAINER Joke Durnez <joke.durnez@gmail.com>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN conda install numpy && \
    conda install scipy && \
    conda install pandas && \
    conda install matplotlib

RUN pip install --no-cache-dir neurodesign > 0.2.02
RUN pip install --no-cache-dir sklearn
RUN pip install --no-cache-dir pdfrw
RUN pip install --no-cache-dir reportlab
RUN pip install --no-cache-dir progressbar
RUN pip install --no-cache-dir seaborn

ENV LD_LIBRARY_PATH=/opt/conda/lib:$LD_LIBRARY_PATH

# Clear apt cache to reduce image size
RUN apt-get update && \
    apt-get install --no-install-recommends -y libgl1-mesa-glx && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
