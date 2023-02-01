FROM python:3.10-slim
LABEL maintainer="Charlie Lewis <clewis@iqt.org>"

ENV PYTHONUNBUFFERED 1

COPY rbqwrapper/requirements.txt requirements.txt
RUN apt-get update && apt-get install --no-install-recommends -y python3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r requirements.txt

COPY rbqwrapper/rbqwrapper.py /rbqwrapper.py
