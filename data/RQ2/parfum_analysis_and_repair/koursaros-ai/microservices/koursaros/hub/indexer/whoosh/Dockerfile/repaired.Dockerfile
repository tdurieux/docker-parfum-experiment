FROM gnes/gnes:latest-buster

RUN pip install --no-cache-dir whoosh

ADD *.py *.yml ./

ENTRYPOINT ["gnes", "index", "--py_path", "whoosh.py"]