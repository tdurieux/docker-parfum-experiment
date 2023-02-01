FROM python:3.6-slim

RUN apt-get update && apt-get install -y \
  gcc \
  git \
  tk \
  python-tk \
  libfftw3-dev \
  libhdf5-serial-dev \
  libmagic-dev \
  curl
COPY ./requirements.txt ./requirements-manual.txt /
RUN pip install --no-cache-dir -r /requirements.txt
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf ~/.cache/pip
RUN mkdir /samples /logs

WORKDIR /malgazer
CMD bash /entrypoint.sh
