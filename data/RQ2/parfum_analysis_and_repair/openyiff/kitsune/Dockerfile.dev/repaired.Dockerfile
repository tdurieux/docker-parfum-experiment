FROM python:3.10

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
		libev-dev \
        libpq-dev \
        curl \
        libmagic1 \
    && pip3 install --no-cache-dir uwsgi && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /app

ENV LANG=C.UTF-8

CMD python3 daemon.py
