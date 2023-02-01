FROM python:3

RUN apt-get update \
  && apt-get install --no-install-recommends -y lzip tar xz-utils \
  && pip install --no-cache-dir gensim && rm -rf /var/lib/apt/lists/*;

COPY ./vectors /vectors

COPY ablation.py /app/ablation.py
COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]