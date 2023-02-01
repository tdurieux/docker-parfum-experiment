FROM python:2.7

COPY requirements.txt /tmp/
RUN pip install --no-cache-dir --requirement /tmp/requirements.txt
COPY . /tmp/
RUN pip install --no-cache-dir /tmp/