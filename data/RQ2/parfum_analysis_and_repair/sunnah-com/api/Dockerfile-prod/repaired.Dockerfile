FROM python:3.8-slim

ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/

RUN apt-get update && \
    apt-get install --no-install-recommends gcc -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir uwsgi && \
    pip install --no-cache-dir -r requirements.txt

RUN groupadd -g 777 appuser && \
    useradd -r -u 777 -g appuser appuser
USER appuser

COPY . /code/
