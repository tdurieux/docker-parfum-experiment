FROM python:3.6
ENV PYTHONUNBUFFERED 1

# mecabをインストールしておく
RUN apt-get update -y && apt-get install --no-install-recommends -y \
  mecab mecab-ipadic-utf8 python-mecab libmecab-dev && rm -rf /var/lib/apt/lists/*;


RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
RUN mkdir -p /usr/src/app/static && rm -rf /usr/src/app/static
WORKDIR /usr/src/app
ADD requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /usr/src/app/
