FROM python:3.7-slim

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update && apt-get install --no-install-recommends -y nano git && rm -rf /var/lib/apt/lists/*;

COPY requirements_dev.txt requirements_dev.txt
RUN pip install --no-cache-dir -r requirements_dev.txt

COPY . /app
WORKDIR /app

RUN python setup.py develop

CMD "/bin/bash"
