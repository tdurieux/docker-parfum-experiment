FROM python:3.7

ARG DEPENDENCIES

RUN pip install --no-cache-dir psycopg2 pymysql mysqlclient pytest pytest-cov
RUN echo "${DEPENDENCIES}" > /tmp/requriements.txt && pip install --no-cache-dir -r /tmp/requriements.txt
RUN pip list
