FROM jupyter/datascience-notebook:python-3.8.6

USER root
RUN mkdir /app && chown jovyan /app

RUN pip install --upgrade pip \
 && pip install --upgrade setuptools

COPY requirements.txt /app

RUN pip install -r /app/requirements.txt

RUN python -m nltk.downloader stopwords

WORKDIR app
