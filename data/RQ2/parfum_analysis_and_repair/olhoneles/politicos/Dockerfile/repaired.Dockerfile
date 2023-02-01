FROM python:3.7

RUN apt-get update && \
	apt-get -y --no-install-recommends install libcurl4-openssl-dev build-essential libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/share/politicos-api
WORKDIR /usr/share/politicos-api

COPY . /usr/share/politicos-api
RUN pip install --no-cache-dir -r /usr/share/politicos-api/requirements.txt
