FROM python:2.7-slim

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
  curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  mkdir /app

WORKDIR /app

# Copy as early as possible so we can cache ...
ADD requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

ADD . .

RUN pip install rasa_core==0.11.3

RUN pip install sklearn_crfsuite
VOLUME ["/app/data"]

EXPOSE 5005 5006

CMD python -m rasa_core.run   --enable_api -c rest  -d data/servicing-bot-en/models/dialogue -u data/servicing-bot-en/models/servicing-bot-en/model-en --endpoints endpoints.yml --credentials credentials.yml --debug
