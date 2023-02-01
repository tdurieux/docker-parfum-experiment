FROM tensorflow/tensorflow:latest-gpu-py3
# tensorflow==1.13.1

# List of common Python packages installed in the Docker image used for this
# challenge. Participants are welcome to suggest other popular Python packages
# to be installed. If necessary, we'll update the Docker image to satisfy the
# need for most participants.
# In the case where you want to use less common packages, you can simply put
# all these packages in the the same folder of your submission (together with
# `model.py`) and the CodaLab platform should be able to find them.
RUN pip install --no-cache-dir numpy==1.16.2
RUN pip install --no-cache-dir pandas==0.24.2
RUN pip install --no-cache-dir jupyter==1.0.0
RUN pip install --no-cache-dir seaborn==0.9.0
RUN pip install --no-cache-dir scipy==1.2.1
RUN pip install --no-cache-dir matplotlib==3.0.3
RUN pip install --no-cache-dir scikit-learn==0.20.3
RUN pip install --no-cache-dir pyyaml==5.1.1
RUN pip install --no-cache-dir psutil==5.6.3
RUN pip install --no-cache-dir h5py==2.9.0
RUN pip install --no-cache-dir keras==2.2.4
RUN pip install --no-cache-dir playsound==1.2.2
RUN pip install --no-cache-dir librosa==0.7.1
RUN pip install --no-cache-dir protobuf==3.7.1
RUN pip install --no-cache-dir xgboost==0.90
RUN pip install --no-cache-dir pyyaml==5.1.1
RUN pip install --no-cache-dir lightgbm==2.2.3
RUN pip install --no-cache-dir torch==1.3.1
RUN pip install --no-cache-dir torchvision==0.4.2

# Packages from AutoNLP
# More info: https://hub.docker.com/r/wahaha909/autonlp
RUN pip install --no-cache-dir jieba==0.39
RUN pip install --no-cache-dir nltk==3.4.4
RUN pip install --no-cache-dir spacy==2.1.6
RUN pip install --no-cache-dir gensim==3.8.0
RUN pip install --no-cache-dir polyglot==16.7.4
RUN pip install --no-cache-dir transformers==2.2.0
# Embedding weights: fastText dim=300 Chinese and English, BERT
# In order to make following commands work, run these commands (in docker/)
# first to download corresponding weights files:
#   curl -C - -O https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/cc.zh.300.vec.gz
#   curl -C - -O https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/cc.en.300.vec.gz
#   curl -C - -O https://storage.googleapis.com/bert_models/2019_05_30/wwm_uncased_L-24_H-1024_A-16.zip
RUN mkdir -p /app && mkdir /app/embedding && cd /app/embedding
COPY cc.zh.300.vec.gz /app/embedding/
COPY cc.en.300.vec.gz /app/embedding/
COPY wwm_uncased_L-24_H-1024_A-16.zip /app/embedding/

# Packages from AutoSpeech
RUN apt-get update && apt-get -y --no-install-recommends install libsndfile1 && rm -rf /var/lib/apt/lists/*;

# Packages to be activated: Following packages are demanded by one of the
# participants. If another participant asks to install one of these packages,
# we'll uncomment corresponding line and rebuild this image.
RUN pip install --no-cache-dir tensorflow_hub==0.7.0
# RUN pip install fastai
# RUN pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/cuda/10.0 nvidia-dali

WORKDIR /app/codalab
ADD VERSION .
