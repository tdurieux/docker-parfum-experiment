FROM locustio/locust:1.2.3

USER root
RUN pip install --no-cache-dir pandas

ADD locustfile.py /locustfile.py

ADD testdata /testdata
