FROM nvidia/cuda
LABEL maintainer "Michael Everett, Björn Lütjens <{mfe}, {lutjens}@mit.edu>"

##
# Disclaimer: This Dockerfile enables to run /scripts/ga3c_cadrl_demo.ipynb
# It is not expected to work w/ the ROS code
##

RUN apt update
RUN apt -y upgrade

# Install tensorflow-gpu w/ python2.7
RUN apt update
RUN apt-get -y --no-install-recommends install python2.7 python-pip python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip2 install --no-cache-dir tensorflow

# Import user environment variable
ARG user
ENV USER $user

# Install Jupyter notebook
RUN pip install --no-cache-dir ipython==5.7 ipykernel==4.10 jupyter

RUN pip install --no-cache-dir matplotlib==2.2.3

COPY ./entrypoint.sh /

# Make ports available to the outside world
# Jupyter
EXPOSE 8888
# TensorBoard
EXPOSE 6006

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]