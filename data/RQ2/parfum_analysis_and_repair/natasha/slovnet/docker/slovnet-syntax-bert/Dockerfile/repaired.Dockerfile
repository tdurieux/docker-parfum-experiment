FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-runtime

RUN S3=https://storage.yandexcloud.net/natasha-slovnet \
    && curl -f -O $S3/01_bert_news/rubert/vocab.txt \
    && curl -f -O $S3/04_bert_syntax/model/rels_vocab.txt \
    && curl -f -O $S3/01_bert_news/model/emb.pt \
    && curl -f -O $S3/04_bert_syntax/model/encoder.pt \
    && curl -f -O $S3/04_bert_syntax/model/head.pt \
    && curl -f -O $S3/04_bert_syntax/model/rel.pt

COPY requirements/app.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN pip install --no-cache-dir -e .

CMD python docker/slovnet-syntax-bert/app.py