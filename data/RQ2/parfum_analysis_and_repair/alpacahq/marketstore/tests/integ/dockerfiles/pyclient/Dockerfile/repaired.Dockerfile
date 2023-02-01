FROM continuumio/miniconda3

COPY requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt

WORKDIR /project
