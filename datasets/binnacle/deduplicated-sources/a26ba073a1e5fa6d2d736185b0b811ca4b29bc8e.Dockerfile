FROM python:3.6

WORKDIR /app

RUN apt-get update -y -qq
RUN apt-get install -y -qq groff pandoc

RUN pip install -U wheel pygments twine
RUN pip install -U awslogs awscli
COPY build-requirements.txt build-requirements.txt
RUN pip install -U -r build-requirements.txt

COPY setup.py setup.py
COPY setup.cfg setup.cfg
COPY awsie/__init__.py awsie/__init__.py
COPY README.md README.md

RUN pandoc --from=markdown --to=rst --output=README.rst README.md

RUN python setup.py develop
