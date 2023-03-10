FROM docker.io/deepprojects/dvc-cc_basic:10.0a

# Often used libraries
RUN pip install --no-cache-dir --user \
        Pillow \
        h5py \
        ipykernel \
        jupyter \
        keras_applications \
        keras_preprocessing \
        matplotlib \
        mock \
        numpy \
        scipy \
        sklearn \
        pandas \
        dvc \
        paramiko \
        pyyaml \
        seaborn \
        pandas

# install tensorflow
RUN pip install --no-cache-dir --user tensorflow-gpu
RUN pip install --no-cache-dir --user tensorboard