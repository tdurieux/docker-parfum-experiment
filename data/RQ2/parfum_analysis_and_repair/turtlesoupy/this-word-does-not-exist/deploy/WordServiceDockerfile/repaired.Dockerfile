FROM continuumio/miniconda3

RUN apt-get update && apt-get install --no-install-recommends -y tar git curl nano wget dialog net-tools build-essential && rm -rf /var/lib/apt/lists/*;
RUN conda update conda && conda create -n title_maker_pro -c pytorch -c stanfordnlp -c conda-forge python=3.7

RUN [ "/bin/bash", "-c", "source activate title_maker_pro \
  && conda install pytorch torchvision cpuonly -c pytorch \
  && conda install -c stanfordnlp stanza" ]

RUN [ "/bin/bash", "-c", "source activate title_maker_pro && python -c 'import stanza; stanza.download(\"en\")'" ]

RUN mkdir -p /app/models
WORKDIR /app/models
RUN curl -f https://storage.googleapis.com/this-word-does-not-exist-models/forward-dictionary-model-v1.tar.gz | tar -xz
RUN curl -f https://storage.googleapis.com/this-word-does-not-exist-models/inverse-dictionary-model-v1.tar.gz | tar -xz
RUN curl -f https://storage.googleapis.com/this-word-does-not-exist-models/forward-urban-dictionary-model-v1.tar.gz | tar -xz
RUN curl -f -O https://storage.googleapis.com/this-word-does-not-exist-models/blacklist.pickle.gz && gunzip blacklist.pickle.gz

WORKDIR /app
COPY ./cpu_deploy_environment.yml .
RUN [ "/bin/bash", "-c", "source activate title_maker_pro && conda env update -f cpu_deploy_environment.yml"]
RUN [ "/bin/bash", "-c", "source activate title_maker_pro && python -c 'from transformers import AutoTokenizer; AutoTokenizer.from_pretrained(\"gpt2\")'"]

COPY ./title_maker_pro title_maker_pro
COPY ./word_service word_service

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/bin/bash", "-c", "source activate title_maker_pro && \
  PYTHONPATH=.:$PYTHONPATH \
  python word_service/wordservice_server.py \
  --forward-model-path models/forward-dictionary-model-v1 \
  --inverse-model-path models/inverse-dictionary-model-v1 \
  --forward-urban-model-path models/forward-urban-dictionary-model-v1 \
  --blacklist-path models/blacklist.pickle \
  --quantize \
  --device cpu \
"]
