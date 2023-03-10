FROM ubuntu:18.04

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y vim && \
  apt-get install --no-install-recommends -y software-properties-common && \
  apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;


RUN \
  curl -f -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
  bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b && \
  rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH=/miniconda/bin:${PATH}

RUN conda update -y conda

COPY ./build build
WORKDIR /app/build
RUN curl -f https://storage.googleapis.com/title-maker-pro-staging/forward-dictionary-model-v1.tar.gz | tar -xz
RUN curl -f https://storage.googleapis.com/title-maker-pro-staging/inverse-dictionary-model-v1.tar.gz | tar -xz
WORKDIR /app

COPY ./cpu_deploy_environment.yml .
RUN conda env create -f cpu_deploy_environment.yml

# Stanza implicitly downloads models
RUN [ "/bin/bash", "-c", "source activate title_maker_pro && python -c 'import stanza; stanza.download(\"en\")'" ]
RUN [ "/bin/bash", "-c", "source activate title_maker_pro && python -c 'from transformers import AutoTokenizer; AutoTokenizer.from_pretrained(\"gpt2\")'"]

COPY ./title_maker_pro title_maker_pro
COPY ./build build

ENTRYPOINT ["/bin/bash", "-c", "source activate title_maker_pro && source build/env_vars.sh && python title_maker_pro/twitter_bot.py --forward-model-path build/forward-dictionary-model-v1 --inverse-model-path build/inverse-dictionary-model-v1 --blacklist-path build/blacklist.pickle"]
