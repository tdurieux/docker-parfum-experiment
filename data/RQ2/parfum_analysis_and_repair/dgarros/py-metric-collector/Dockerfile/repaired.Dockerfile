FROM python:3.7
LABEL maintainer="dgarros@gmail.com"

RUN mkdir /source
WORKDIR /source
USER root

COPY . /source
RUN pip install --no-cache-dir -r /source/requirements.txt

RUN python setup.py develop

RUN apt-get -y update && apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/local/bin/metric-collector"]
