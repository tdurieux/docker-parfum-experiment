FROM datmo/python-base:gpu-py35

MAINTAINER Datmo devs <dev@datmo.com>

RUN pip --no-cache-dir install \
        Cython \
        h5py \
        requests \
        tabulate \
        matplotlib \
        numpy==1.14.5 \
        pandas \
        path.py \
        pyyaml \
        scipy \
        six \
        sklearn \
        sympy \
        Pillow \
        zmq \
        seaborn \
        wheel \
        deap \
        update_checker \
        tqdm \
        stopit \
        imbalanced-learn \
        tpot \
        datmo

# Install cmake
RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

# Install lightgbm
RUN pip install --no-cache-dir lightgbm

# Install xgboost
RUN git clone --recursive https://github.com/dmlc/xgboost \
    && cd xgboost \
    && mkdir build \
    && cd build \
    && cmake .. -DUSE_CUDA=ON \
    && make -j$(nproc) \
    && cd .. \
    && make -j$(nproc) \
    && cd python-package \
    && python setup.py install \
    && cd ../.. \
    && rm -rf xgboost

###########
#
#      NEW CONTRIBUTORS:
# Please add new pip/apt installs in this block. Don't forget a "&& \" at the end
# of all non-final lines. Thanks!
#
###########



##### ^^^^ Add new contributions above here ^^^^ #####

