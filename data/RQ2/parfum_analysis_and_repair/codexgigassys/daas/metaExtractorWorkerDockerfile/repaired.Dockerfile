FROM python:3.8.0-buster
RUN mkdir /daas
WORKDIR /daas
COPY requirements_worker.txt /tmp/requirements_worker.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip --retries 10 --no-cache-dir install -r /tmp/requirements_worker.txt
