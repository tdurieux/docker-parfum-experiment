FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-runtime

ENV DEBIAN_FRONTEND=noninteractive

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN pip install --no-cache-dir matplotlib==3.2.1
RUN pip install --no-cache-dir pandas==1.0.3
RUN pip install --no-cache-dir netCDF4==1.5.3
RUN pip install --no-cache-dir scipy==1.5.4
RUN pip install --no-cache-dir statsmodels==0.12.2
RUN pip install --no-cache-dir scikit-learn==0.24.2

RUN /bin/bash -c "echo \"PS1='🐳  \[\033[1;36m\]\h \[\033[1;34m\]\W\[\033[0;35m\] \[\033[1;36m\]# \[\033[0m\]\$ '\" >> /root/.bashrc "

WORKDIR /workspace
