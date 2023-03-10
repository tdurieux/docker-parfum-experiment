FROM floydhub/dl-python:4.1.0-gpu-py3.55
MAINTAINER Floyd Labs "support@floydhub.com"

# Script to install the NodeSource Node.js 10.x LTS Dubnium
# repo onto a Debian or Ubuntu system.
RUN wget -qO- https://deb.nodesource.com/setup_10.x | bash -

# Install Nodejs and supervisor for tensorboard and jupyter lab
# lua5.1 and libav-tools for gym retro
# graphviz for visualization
RUN apt-get update && apt-get install --no-install-recommends -y \
        supervisor \
        binutils \
        nodejs \
        lua5.1 \
        nginx \
        graphviz \
        axel \
        imagemagick \
  && apt-get clean \
  && apt-get autoremove \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/*

COPY tensorboard/tensorboard.conf /etc/supervisor/conf.d/

RUN pip --no-cache-dir install \
        floyd-cli \
        flask==1.1.2 \
        uwsgi==2.0.18 \
        pydot \
        dlib \
        incremental \
        nltk \
        notebook \
        jupyterlab==2.1.2 \
        gym[atari,box2d,classic_control] \
        textacy \
        scikit-learn \
        scikit-image \
        #scikit-umfpack=='0.3.1' \
        spacy \
        tqdm \
        wheel \
        kaggle \
        h5py \
        seaborn \
        plotly \
        annoy \
        pynvrtc \
        menpo \
        cupy-cuda102 \
        # TOADD RAPIDS
        gym-retro \
        retrowrapper \
    && rm -rf /tmp/* /var/tmp/*


# Install and Enable jupyter-widgets - see https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@2.0
# Update Cmake to the latest version to build xgboost on CUDA
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add - \
  && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' \
  && apt-get update \
  && apt-get install --no-install-recommends -y cmake \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/*


# Install xgboost
RUN git clone --branch v1.0.2 --recursive https://github.com/dmlc/xgboost \
    && cd xgboost \
    && mkdir build \
    && cd build \
    && cmake .. -DUSE_CUDA=ON \
    && make -j$(nproc) \
    && cd .. \
    && cd python-package \
    && python setup.py install \
    && cd ../.. \
    && rm -rf xgboost

# TO CONSIDER: Install Anaconda
# RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.0-Linux-x86_64.sh \
#     && bash Anaconda3-5.0.0-Linux-x86_64.sh -b \
#     && rm Anaconda3-5.0.0-Linux-x86_64.sh