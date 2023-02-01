FROM python:3.6

RUN curl -f https://storage.yandexcloud.net/natasha-navec/packs/navec_news_v1_1B_250K_300d_100q.tar -o navec.tar \
    && curl -f https://storage.yandexcloud.net/natasha-slovnet/packs/slovnet_morph_news_v1.tar -o pack.tar

RUN pip install --no-cache-dir aiohttp==3.6.1

COPY requirements/main.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN pip install --no-cache-dir -e .

CMD python docker/slovnet-morph/exec/app.py
