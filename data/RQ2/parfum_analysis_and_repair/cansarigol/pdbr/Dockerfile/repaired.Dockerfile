FROM python:3.7.9

ENV PYTHONUNBUFFERED=0

RUN pip install --no-cache-dir pip \
 && pip install --no-cache-dir nox

WORKDIR /pdbr
COPY . .

RUN nox --sessions check
RUN nox --sessions test
