FROM nvcr.io/nvidia/pytorch:19.03-py3

#- Install system requirements
RUN apt-get update
RUN apt-get install --no-install-recommends -y git vim wget unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python python-pip && rm -rf /var/lib/apt/lists/*;

#- Install additional Python3 dependencies
RUN pip install --no-cache-dir spacy && python -m spacy download en

#- Get IAC code
WORKDIR /
RUN git clone https://github.com/vliu15/dialogue-seq2seq.git

#- (Optional) Download data and preprocess
# WORKDIR /dialogue-seq2seq
# RUN sh setup.sh
