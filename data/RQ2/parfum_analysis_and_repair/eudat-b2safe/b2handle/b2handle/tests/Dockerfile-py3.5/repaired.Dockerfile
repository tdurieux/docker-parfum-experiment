FROM       python:3.5

RUN pip install --no-cache-dir \
           mock \
           coverage \
           nose

ADD        . /opt/B2HANDLE
RUN        cd /opt/B2HANDLE && \
           python setup.py install

WORKDIR    /opt/B2HANDLE/b2handle/tests

CMD ["./docker-entrypoint.sh", "coverage"]