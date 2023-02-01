FROM python:3.6-slim as builder
# if this installation process changes, the enterprise container needs to be
# updated as well
WORKDIR /build
COPY . .
RUN python setup.py sdist bdist_wheel
RUN find dist -maxdepth 1 -mindepth 1 -name '*.tar.gz' -print0 | xargs -0 -I {} mv {} rasa.tar.gz

FROM python:3.6-slim

SHELL ["/bin/bash", "-c"]

RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  build-essential \
  wget \
  openssh-client \
  graphviz-dev \
  pkg-config \
  git-core \
  openssl \
  libssl-dev \
  libffi6 \
  libffi-dev \
  libpng-dev \
  libpq-dev \
  curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  mkdir /install && \
  mkdir /app

WORKDIR /install

# Copy as early as possible so we can cache ...
COPY alt_requirements/ ./alt_requirements
COPY requirements.txt .

RUN pip install -r alt_requirements/requirements_full.txt

COPY --from=builder /build/rasa.tar.gz .
RUN pip install ./rasa.tar.gz[sql,spacy,mitie]

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends wget \
    && wget -P /app/data/ https://s3-eu-west-1.amazonaws.com/mitie/total_word_feature_extractor.dat \
    && apt-get remove -y wget \
    && apt-get autoremove -y

RUN pip install https://github.com/explosion/spacy-models/releases/download/en_core_web_md-2.1.0/en_core_web_md-2.1.0.tar.gz#egg=en_core_web_md==2.1.0 --no-cache-dir > /dev/null \
    && python -m spacy link en_core_web_md en \
    && pip install https://github.com/explosion/spacy-models/releases/download/de_core_news_sm-2.1.0/de_core_news_sm-2.1.0.tar.gz#egg=de_core_news_sm==2.1.0 --no-cache-dir > /dev/null \
    && python -m spacy link de_core_news_sm de

COPY sample_configs/config_pretrained_embeddings_spacy_duckling.yml /app/config.yml

VOLUME ["/app"]
WORKDIR /app

EXPOSE 5005

ENTRYPOINT ["rasa"]

CMD ["--help"]
