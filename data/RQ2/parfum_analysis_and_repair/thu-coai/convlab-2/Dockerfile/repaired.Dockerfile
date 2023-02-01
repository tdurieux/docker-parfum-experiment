FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN apt-get install -y --no-install-recommends python3.7 python3-pip build-essential libssl-dev libffi-dev python3.7-dev && rm -rf /var/lib/apt/lists/*;

RUN python3.7 -m pip install --upgrade pip
RUN python3.7 -m pip install setuptools wheel

RUN which python3.7
RUN which pip3

RUN ln -f -s /usr/bin/python3.7 /usr/bin/python
RUN ln -f -s /usr/bin/pip3 /usr/bin/pip
RUN python --version

RUN pip install --no-cache-dir nltk==3.4
RUN pip install --no-cache-dir tqdm==4.30
RUN pip install --no-cache-dir checksumdir==1.1
RUN pip install --no-cache-dir dataclasses
RUN pip install --no-cache-dir visdom
RUN pip install --no-cache-dir Pillow
RUN pip install --no-cache-dir future
RUN pip install --no-cache-dir torch
RUN pip install --no-cache-dir numpy==1.15.0
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir scikit-learn==0.20.3
RUN pip install --no-cache-dir pytorch-pretrained-bert==0.6.1
RUN pip install --no-cache-dir transformers==2.3.0
RUN pip install --no-cache-dir tensorboard==1.14.0
RUN pip install --no-cache-dir tensorboardX==1.7
RUN pip install --no-cache-dir tokenizers==0.8.0
RUN pip install --no-cache-dir allennlp==0.9.0
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir simplejson
RUN pip install --no-cache-dir spacy
RUN pip install --no-cache-dir unidecode
RUN pip install --no-cache-dir jieba
RUN pip install --no-cache-dir embeddings
RUN pip install --no-cache-dir quadprog
RUN pip install --no-cache-dir pyyaml
RUN pip install --no-cache-dir fuzzywuzzy
RUN pip install --no-cache-dir python-Levenshtein
RUN pip install --no-cache-dir gtts
RUN pip install --no-cache-dir DeepSpeech
RUN pip install --no-cache-dir pydub

RUN [ "python", "-c", "import nltk; nltk.download('stopwords')" ]

WORKDIR /root

CMD ["/bin/bash"]
