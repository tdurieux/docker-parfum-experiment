FROM python:3-slim

ADD requirements.txt .

RUN apt-get update -yqq && \
    apt-get install --no-install-recommends -yqq build-essential procps gawk && \
    CFLAGS=-fcommon pip3 --no-cache-dir install -r requirements.txt && rm -rf /var/lib/apt/lists/*;

ADD . .

CMD ["nice", "-n", "19", "python3", "stats.py"]

