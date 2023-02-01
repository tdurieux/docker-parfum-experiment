FROM python:3.7

RUN pip3 install --no-cache-dir requests markdown_strings

WORKDIR /job-insighter

COPY insight.py /job-insighter/
