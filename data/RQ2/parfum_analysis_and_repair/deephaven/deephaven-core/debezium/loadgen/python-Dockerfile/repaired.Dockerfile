FROM python:3

EXPOSE 8090

RUN apt-get update && apt-get -qy --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir barnum kafka-python mysql-connector-python requests wait-for-it

RUN mkdir /loadgen
COPY generate_load.py /loadgen
COPY python-docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["python-docker-entrypoint.sh"]
