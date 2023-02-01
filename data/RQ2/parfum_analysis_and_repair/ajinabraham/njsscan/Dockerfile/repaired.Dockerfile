FROM python:3.8-slim-buster

COPY . /usr/src/njsscan

WORKDIR /usr/src/njsscan

RUN pip install --no-cache-dir -e .

ENTRYPOINT ["njsscan"]