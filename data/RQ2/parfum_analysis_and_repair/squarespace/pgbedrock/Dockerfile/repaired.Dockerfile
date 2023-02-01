FROM python:3.6

VOLUME /opt
WORKDIR /opt

COPY setup.py /opt/
COPY requirements.txt /opt/
COPY pgbedrock /opt/pgbedrock
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir .
RUN pip install --no-cache-dir --force-reinstall psycopg2

ENTRYPOINT ["pgbedrock"]
