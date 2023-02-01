FROM python:2.7-alpine

ADD requirements-build.txt /

RUN pip install --no-cache-dir -r /requirements-build.txt

ADD registry.py /

ENTRYPOINT ["/registry.py"]
