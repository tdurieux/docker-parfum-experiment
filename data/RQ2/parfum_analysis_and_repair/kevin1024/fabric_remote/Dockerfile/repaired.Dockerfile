FROM python:2.7

RUN pip install --no-cache-dir pyyaml requests

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN python setup.py install

VOLUME ["/data"]

ENV FABFILE_PATH "/data/fabfile.py"

CMD ["fabric-remote-server"]

EXPOSE 1234
