FROM python:3.7


RUN apt-get update && apt-get install --no-install-recommends -y gcc default-libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

COPY page_api/requirements.txt /

RUN pip install --no-cache-dir -r /requirements.txt

COPY page_api/src/ /app
COPY database/schema.py /app
WORKDIR /app
