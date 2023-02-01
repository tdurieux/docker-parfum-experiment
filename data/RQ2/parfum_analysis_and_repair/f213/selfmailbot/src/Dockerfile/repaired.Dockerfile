FROM python:3.7-slim
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update && \
  apt-get --no-install-recommends -y --assume-yes install build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir uwsgi

COPY . /srv
WORKDIR /