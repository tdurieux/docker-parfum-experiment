# Build local DS env on mac OS X
# start with  anaconda3 python 3

#############  install anaconda3 ################

FROM continuumio/anaconda3
MAINTAINER "yen"

#############  install library ################

RUN apt-get update && apt-get install --no-install-recommends -y libgtk2.0-dev && apt-get install -y --no-install-recommends wget && \
    /opt/conda/bin/conda install jupyter -y && \
    /opt/conda/bin/conda install numpy pandas scikit-learn matplotlib seaborn pyyaml && \
    /opt/conda/bin/conda upgrade dask && \
    pip install --no-cache-dir --upgrade pip && \
    pip freeze list && rm -rf /var/lib/apt/lists/*;

#############  run commands  ################

RUN ["mkdir", "notebooks"]

COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter ports
EXPOSE 8888

# Store notebooks in this mounted directory
VOLUME /notebooks

#############  run notebook  ################

# dev
