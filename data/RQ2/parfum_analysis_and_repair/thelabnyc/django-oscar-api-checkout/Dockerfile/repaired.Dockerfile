FROM python:3.9

RUN mkdir /code
WORKDIR /code

RUN apt-get update && \
    apt-get install --no-install-recommends -y gettext && \
    rm -rf /var/lib/apt/lists/*

ADD . /code/
RUN pip install --no-cache-dir -e .[development]

RUN mkdir /tox
ENV TOX_WORK_DIR='/tox'
