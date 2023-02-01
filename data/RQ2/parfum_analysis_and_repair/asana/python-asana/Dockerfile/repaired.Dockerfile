FROM ubuntu:14.04

RUN apt-get update

RUN apt-get install --no-install-recommends -y python python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

ADD requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

ADD asana /app/asana
ADD tests /app/tests
ADD setup.py /app/setup.py

RUN find . -name '*.pyc' -delete

RUN python --version
RUN python -m pytest

RUN python3 --version
RUN python3 -m pytest

RUN python setup.py bdist_egg
RUN python3 setup.py bdist_egg
