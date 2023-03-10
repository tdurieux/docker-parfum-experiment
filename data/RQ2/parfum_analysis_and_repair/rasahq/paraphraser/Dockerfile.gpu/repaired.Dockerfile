FROM nvidia/cuda:11.0.3-runtime-ubuntu20.04

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
      wget \
      build-essential \
      curl \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget --no-check-certificate -O miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash miniconda.sh -b \
    && rm -f miniconda.sh

ENV PATH="/root/miniconda3/bin:${PATH}"

WORKDIR /home

COPY download_model.sh download_model.sh
RUN ./download_model.sh

RUN conda install pytorch==1.4.0 torchvision==0.5.0 -c pytorch

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN tar -xvf m39v1.tar && rm -f m39v1.tar

COPY src src/
COPY test_bin test_bin/
COPY run_paraphraser.py ./

ENTRYPOINT ["python", "run_paraphraser.py"]

