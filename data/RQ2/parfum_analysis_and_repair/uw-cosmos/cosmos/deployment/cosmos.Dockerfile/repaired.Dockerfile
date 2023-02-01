FROM nvidia/cuda:10.1-devel-ubuntu18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update

RUN apt-get install --no-install-recommends -y --allow-unauthenticated tesseract-ocr && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
    ghostscript \
    gcc \
    libmysqlclient-dev \
    wget \
    tesseract-ocr \
    apt-transport-https \
    libgl1-mesa-glx \
    build-essential \
    libpython3.8-dev \
    python3.8 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN python3.8 -m pip install -U pip
RUN python3.8 -m pip install -v numpy

RUN DEBIAN_FRONTEND="noninteractive" TZ=America/New_York apt-get --no-install-recommends install -y python3-opencv && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

RUN python3.8 -m pip install torch==1.6.0+cu101 torchvision==0.7.0+cu101 -f https://download.pytorch.org/whl/torch_stable.html

# Need this first for opencv
RUN python3.8 -m pip install scikit-build
RUN python3.8 -m pip install cmake

RUN python3.8 -m pip install \
    pandas \
    dask['complete'] \
    scikit-learn \
    sqlalchemy \
    click \
    beautifulsoup4 \
    tqdm \
    pyarrow \
    tensorboard \
    scikit-image \
    xgboost \
    pdfminer.six \
    tensorboardx \
    gunicorn \
    flask \
    pascal-voc-writer \
    pytesseract \
    hyperyaml \
    transformers \
    elasticsearch_dsl \
    opencv-python \
    fasttext \
    ftfy
