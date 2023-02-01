FROM python:3.7

ADD . /gluonts

RUN pip install --no-cache-dir -r /gluonts/requirements/requirements-mxnet.txt
RUN pip install --no-cache-dir /gluonts[shell]

ENTRYPOINT ["python", "-m", "gluonts.shell"]
