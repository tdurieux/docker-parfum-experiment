FROM python:3.9

COPY ./test/perf/test-requirements.txt /test-requirements.txt

RUN pip install --no-cache-dir -r test-requirements.txt

RUN pip install --no-cache-dir bs4 docopt flask msgpack-python nanomsg pyzmq uvloop

COPY . /package

WORKDIR /package

RUN pip install --no-cache-dir -r /package/requirements.txt

CMD python test/perf/perftest.py
