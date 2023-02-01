FROM tensorflow/tensorflow:latest-gpu-py3-jupyter

RUN apt install --no-install-recommends -y rsync \
                   htop \
                   wget && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pillow==5.4.1 \
                requests \
                tqdm \
                scipy

RUN mkdir stylegan
WORKDIR /stylegan