FROM python:2.7.16-slim-stretch
ENV REFRESHED_AT 2019-03-31
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y git curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /code
# This allows us to cache the pip install stage
ADD requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt

ADD . /code
RUN pip install --no-cache-dir -e .
RUN cp /code/settings.sample.py /code/settings.py
