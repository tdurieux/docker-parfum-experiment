FROM python:2.7

RUN pip install --no-cache-dir MYSQL-python SQLAlchemy Jinja2 python-dateutil

ADD . /sortinghat

WORKDIR /sortinghat

RUN python setup.py install