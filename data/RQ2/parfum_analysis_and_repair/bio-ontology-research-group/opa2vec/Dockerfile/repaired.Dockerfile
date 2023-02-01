FROM groovy:2.5

USER root

WORKDIR /tmp

RUN apt-get update && \
  apt-get install --no-install-recommends -y python python-pip perl && \
  pip install --no-cache-dir gensim && rm -rf /var/lib/apt/lists/*;

COPY . .

ENTRYPOINT ["python", "runOPA2Vec.py"]
