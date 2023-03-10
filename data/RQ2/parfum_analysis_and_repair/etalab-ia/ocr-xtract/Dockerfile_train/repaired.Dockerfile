FROM mfeurer/auto-sklearn:master

COPY requirements.txt requirements.txt
COPY requirements_train.txt requirements_train.txt

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris

RUN apt-get update \
    && apt-get install --no-install-recommends git ffmpeg libsm6 libxext6 poppler-utils -y \
    && pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -r requirements_train.txt \
    && pip cache purge \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.cache/pip

RUN python3 -m spacy download fr_core_news_lg

COPY download_doctr_models.py .
RUN python3 download_doctr_models.py

COPY . .
WORKDIR .
CMD [ "streamlit", "run", "app_local_fdp.py", "--server.enableCORS=false", "--server.enableXsrfProtection=false","--server.enableWebsocketCompression=false" ]
