FROM python:3.7

ADD . /pygrams
WORKDIR /pygrams

RUN pip install --no-cache-dir -e .

ENTRYPOINT [ "python", "./pygrams.py" ]