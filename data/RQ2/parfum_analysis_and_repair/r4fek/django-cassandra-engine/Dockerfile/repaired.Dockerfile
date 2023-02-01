FROM python:3.8
ENV PYTHONUNBUFFERED=1
ENV CASS_HOST=cassandra
RUN apt-get -y update && apt-get -y --no-install-recommends install wait-for-it && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade


RUN mkdir /code
WORKDIR /code
RUN pip install --no-cache-dir poetry
ADD . /code/
RUN poetry install

EXPOSE 8000
