FROM python:3.6-slim

MAINTAINER Bryce Handerson

RUN apt update && apt install --no-install-recommends -y python3-dev libmagic-dev && rm -rf /var/lib/apt/lists/*;

COPY . /src
RUN pip install --no-cache-dir /src

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:5000", "pbnh.run:app"]
EXPOSE 5000
