FROM gcr.io/kaggle-images/python:v88

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
COPY requirements.txt .

# mecab
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y mecab libmecab-dev mecab-ipadic-utf8 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir -q https://github.com/pfnet-research/xfeat/archive/master.zip
