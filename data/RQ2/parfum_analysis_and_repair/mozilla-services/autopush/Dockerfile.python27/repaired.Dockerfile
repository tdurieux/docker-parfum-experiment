FROM python:2.7

RUN mkdir -p /app
COPY . /app

WORKDIR /app
ENV PATH=$PATH:/root/.cargo/bin

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y -qq libexpat1-dev gcc libssl-dev libffi-dev && \
    make clean && \
    pip install --no-cache-dir -r requirements.txt && \
    python setup.py develop && rm -rf /var/lib/apt/lists/*;

CMD ["autopush"]
