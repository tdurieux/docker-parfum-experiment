FROM python:3.7.12-slim-buster

ADD ./requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update \
	&& apt-get install --no-install-recommends zip -y && rm -rf /var/lib/apt/lists/*;
