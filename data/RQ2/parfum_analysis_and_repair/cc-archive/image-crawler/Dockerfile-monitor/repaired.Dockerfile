FROM python:3.7
RUN pip install --no-cache-dir pipenv

WORKDIR /monitor
COPY . /monitor/
RUN apt-get update
RUN pipenv install
ENV PYTHONUNBUFFERED 1
CMD PYTHONPATH=. pipenv run python crawl_monitor/monitor.py
