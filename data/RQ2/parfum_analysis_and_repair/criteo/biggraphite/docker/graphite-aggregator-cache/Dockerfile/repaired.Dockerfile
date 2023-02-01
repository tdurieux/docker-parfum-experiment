FROM python:3.6
RUN pip install --no-cache-dir cassandra-driver
COPY . /bg/
WORKDIR /bg
ENV GRAPHITE_NO_PREFIX=true
RUN pip install --no-cache-dir carbon \
     && pip install --no-cache-dir -r requirements.txt \
     && pip install --no-cache-dir -e .
WORKDIR /conf
ENTRYPOINT ["bg-carbon-cache", "--debug", "--nodaemon", "--conf=carbon.conf", "start"]
