FROM python:2.7-slim

MAINTAINER James Royal <jhr.atx@gmail.com>

ADD . /code
WORKDIR /code
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "-u", "ids-slack.py"]