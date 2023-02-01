# Using official python runtime base image
FROM python:2.7

RUN apt-get update
RUN apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir MySQL-python

CMD ["python"]