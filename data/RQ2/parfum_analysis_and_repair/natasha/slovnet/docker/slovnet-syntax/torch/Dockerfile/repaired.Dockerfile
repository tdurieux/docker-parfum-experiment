FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-runtime

RUN S3=https://storage.yandexcloud.net/ \
    && curl -f -O $S3/natasha-slovnet/07_syntax/model/shape.pt \
    && curl -f -O $S3/natasha-slovnet/07_syntax/model/encoder.pt \
    && curl -f -O $S3/natasha-slovnet/07_syntax/model/head.pt \
    && curl -f -O $S3/natasha-slovnet/07_syntax/model/rel.pt \
    && curl -f -O $S3/natasha-slovnet/07_syntax/model/rels_vocab.txt \
    && curl -f -L $S3/natasha-navec/navec_news_v1_1B_250K_300d_100q.tar > navec.tar

COPY requirements/app.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN pip install --no-cache-dir -e .

CMD python docker/slovnet-syntax/torch/app.py
