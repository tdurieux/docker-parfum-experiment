FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-runtime

RUN S3=https://storage.yandexcloud.net/natasha-slovnet \
    && curl -f -O $S3/01_bert_news/rubert/vocab.txt \
    && curl -f -O $S3/01_bert_news/model/emb.pt \
    && curl -f -O $S3/02_bert_ner/model/encoder.pt \
    && curl -f -O $S3/02_bert_ner/model/ner.pt

COPY requirements/app.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN pip install --no-cache-dir -e .

CMD python docker/slovnet-ner-bert/app.py
