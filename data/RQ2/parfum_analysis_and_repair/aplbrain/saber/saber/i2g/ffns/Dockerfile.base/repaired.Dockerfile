FROM tensorflow/tensorflow:1.14.0-gpu

LABEL maintainer="Jordan Matelsky <jordan.matelsky@jhuapl.edu>"

RUN apt update && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir scikit-image scipy numpy tensorflow-gpu h5py pillow absl-py
RUN git clone https://github.com/google/ffn/ \
    && cd ffn \
    && git checkout 30decd27d9d4f3ef5768f2608c8c4d3350f8232b

