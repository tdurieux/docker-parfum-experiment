FROM python:3.7
ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir django-sslserver
RUN pip install --no-cache-dir tabula-py
RUN pip install --no-cache-dir hickory

RUN apt-get update \
    && apt-get install --no-install-recommends -y openjdk-11-jdk \
    && apt-get install --no-install-recommends -y ant \
    && apt-get clean; rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/share/nltk_data \
    && cd /usr/share/nltk_data \
    && mkdir -p sentiment corpora \
    && curl -f https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/stopwords.zip > corpora/stopwords.zip \
    && curl -f https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/sentiment/vader_lexicon.zip > sentiment/vader_lexicon.zip

COPY . /code/