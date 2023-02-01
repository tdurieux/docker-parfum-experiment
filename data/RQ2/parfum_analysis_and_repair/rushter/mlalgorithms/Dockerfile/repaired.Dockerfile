FROM python:3

RUN mkdir -p /var/app
WORKDIR /var/app
COPY . /var/app

# install scipy & numpy
# install required packages
RUN pip install --no-cache-dir scipy numpy && \
    pip install --no-cache-dir .
