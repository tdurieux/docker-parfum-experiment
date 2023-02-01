FROM python:3.7-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y gcc libmariadb-dev && rm -rf /var/lib/apt/lists/*;

COPY . /app

WORKDIR /app/pip
RUN pip install --no-cache-dir --upgrade pip
RUN python pip-install.py
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements.DEVELOPMENT.txt

WORKDIR /app