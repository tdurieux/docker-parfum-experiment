FROM python:3.5
MAINTAINER SZ

RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
COPY ./monitor /monitor
RUN pip3 install --no-cache-dir -r /monitor/requirements.txt


