FROM python:3

LABEL maintainer="mike.place@elastic.co"
WORKDIR /
COPY requirements.txt /dyno/requirements.txt
RUN pip3 install --no-cache-dir -r dyno/requirements.txt
COPY . /dyno
ENTRYPOINT  ["./dyno/entrypoint.sh"]
