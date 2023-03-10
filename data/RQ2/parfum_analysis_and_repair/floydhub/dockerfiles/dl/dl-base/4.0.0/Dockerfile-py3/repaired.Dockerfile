FROM floydhub/dl-python:4.0.0-py3.50
MAINTAINER Floyd Labs "support@floydhub.com"

# TODO: merge bazel update to dl-deps
ENV BAZEL_VERSION 0.24.1

RUN curl -f -LO "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel_${BAZEL_VERSION}-linux-x86_64.deb" \
    && dpkg --force-confnew -i bazel_*.deb \
    && apt-get clean \
    && rm bazel_*.deb

# Script to install the NodeSource Node.js 8.x LTS Carbon
# repo onto a Debian or Ubuntu system.
RUN wget -qO- https://deb.nodesource.com/setup_8.x | bash -

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
        flask==1.1.1 \
        uwsgi==2.0.18 \
        pydot \
        dlib \
        incremental \
        nltk \
        jupyterlab==1.2.3 \
        gym[atari,box2d,classic_control] \
        textacy \
        scikit-learn \
        scikit-image \
        scikit-umfpack \
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
        gym-retro \
        retrowrapper \
    && rm -rf /tmp/* /var/tmp/*


# Install and Enable jupyter-widgets
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.1

# Install xgboost
RUN git clone --branch v0.90 --recursive https://github.com/dmlc/xgboost \
    && cd xgboost \
    && make -j$(nproc) \
    && cd python-package \
    && python setup.py install \
    && cd ../.. \
    && rm -rf xgboost

# TO CONSIDER: Install Anaconda
# RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.0-Linux-x86_64.sh \
#     && bash Anaconda3-5.0.0-Linux-x86_64.sh -b \
#     && rm Anaconda3-5.0.0-Linux-x86_64.sh
