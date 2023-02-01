FROM python:3.10
MAINTAINER Shaun Martin <shaun@samsite.ca>

VOLUME /code

ADD requirements.txt /tmp/
ADD test-requirements.txt /tmp/

RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    pip install --no-cache-dir -r /tmp/test-requirements.txt

CMD cd /code && python -m pytest
