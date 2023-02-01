FROM python:2.7
MAINTAINER CT

RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev libffi-dev libsasl2-dev libldap2-dev && rm -rf /var/lib/apt/lists/*;
COPY ./analyzer/requirements.txt /analyzer/requirements.txt
RUN pip install --no-cache-dir -r /analyzer/requirements.txt

COPY ./analyzer /analyzer

