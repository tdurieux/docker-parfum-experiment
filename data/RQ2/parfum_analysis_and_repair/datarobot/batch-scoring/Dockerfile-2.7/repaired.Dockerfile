FROM python:2.7

COPY requirements-base.txt requirements-py27.txt requirements-test.txt /opt/project/

WORKDIR /opt/project

RUN pip install --no-cache-dir -r requirements-base.txt -r -r

COPY . /opt/project

RUN pip install --no-cache-dir -e .

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/bash"]
