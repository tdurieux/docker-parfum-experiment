FROM python:3.8
ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code

RUN apt-get update && \
    apt-get install --no-install-recommends -y gettext && \
    rm -rf /var/lib/apt/lists/*

ADD requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt

ADD . /code/
RUN pip install --no-cache-dir -e .[development,msgpack,kafka,kinesis]

RUN mkdir /tox
ENV TOX_WORK_DIR='/tox'
