# FROM tensorflow/tensorflow:latest-py3
FROM intelaipg/intel-optimized-tensorflow:latest-mkl-py3
RUN apt install --no-install-recommends -y rsync \
                   htop \
                   wget && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pillow==5.4.1 \
                requests \
                tqdm \
                scipy

RUN pip install --no-cache-dir jupyter

RUN mkdir stylegan
WORKDIR /stylegan