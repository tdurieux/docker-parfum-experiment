FROM python:3-alpine

RUN apk --no-cache add libmagic

WORKDIR /usr/src/panoptes-python-client

COPY setup.py .

RUN pip install --no-cache-dir .[testing,docs]

COPY . .

RUN pip install --no-cache-dir -U .[testing,docs]
