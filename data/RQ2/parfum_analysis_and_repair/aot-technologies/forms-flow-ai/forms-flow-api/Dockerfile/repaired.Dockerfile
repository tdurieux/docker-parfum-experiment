#Author: Kurian Benoy
FROM python:3.9-slim-buster

WORKDIR /forms-flow-api/app
COPY requirements.txt .
ENV PATH=/venv/bin:$PATH

RUN : \
    && python3 -m venv /venv \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

ADD . /forms-flow-api/app
RUN pip install --no-cache-dir -e .

EXPOSE 5000
RUN chmod u+x ./entrypoint
ENTRYPOINT ["/bin/sh", "entrypoint"]
