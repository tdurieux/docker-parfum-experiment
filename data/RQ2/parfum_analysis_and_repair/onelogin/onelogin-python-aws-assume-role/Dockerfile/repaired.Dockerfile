FROM python:3.6

COPY . /

RUN pip install --no-cache-dir awscli --upgrade --user
RUN pip install --no-cache-dir boto3 lxml onelogin
RUN python setup.py develop
