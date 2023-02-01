# This is a dockerfile that can be used to easily host and create an environment for specter embeddings.
FROM python:3.7-slim
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install git wget && apt-get -y --no-install-recommends install --upgrade build-essential && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/allenai/specter.git
WORKDIR "specter"
RUN wget https://ai2-s2-research-public.s3-us-west-2.amazonaws.com/specter/archive.tar.gz && tar -xzvf archive.tar.gz && rm archive.tar.gz

RUN apt-get -y --no-install-recommends install --upgrade gcc && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip cython

# A different version of allenNLP is installed to resolve dependency issues.
RUN pip install --no-cache-dir allennlp==2.4.0
RUN pip install --no-cache-dir -r requirements.txt

RUN python setup.py install
ENTRYPOINT /bin/bash

