FROM python:3.7

LABEL authors="seanchang@kklab.com"

ARG SPACY_MODEL=zh_core_web_sm

# install system requires
RUN apt update && \
    apt install --no-install-recommends -y libmariadb-dev redis-tools python3-dev && rm -rf /var/lib/apt/lists/*;

# install python system requires
RUN pip install --no-cache-dir poetry && \
    pip cache purge

# argo cli
RUN curl -f -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.1.5/argo-linux-amd64.gz && \
    gunzip argo-linux-amd64.gz && \
    chmod +x argo-linux-amd64 && \
    mv ./argo-linux-amd64 /usr/local/bin/argo

# set workdir
WORKDIR /app

# copy project to workdir
COPY . .
RUN poetry install
RUN poetry run spacy download $SPACY_MODEL
