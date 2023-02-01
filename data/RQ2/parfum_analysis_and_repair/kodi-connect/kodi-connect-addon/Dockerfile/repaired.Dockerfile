# FROM python:2.7
FROM python:3.6

ENV HOME=/home/python

RUN apt-get --allow-releaseinfo-change update && \
  apt-get install --no-install-recommends -y zip && \
  pip install --no-cache-dir pylint flake8 ipdb && \
  touch /usr/bin/cec-client && chmod +x /usr/bin/cec-client && \
  useradd -m python && \
  mkdir -p $HOME/app && \
  chown -R python:python $HOME && rm -rf /var/lib/apt/lists/*;

# Virtualenv
RUN pip install --no-cache-dir virtualenv

# Kodi dependencies
RUN pip install --no-cache-dir future==0.17.1

# Development dependencies
RUN pip install --no-cache-dir mypy black pylint flake8

WORKDIR $HOME/app

USER python

RUN bash
