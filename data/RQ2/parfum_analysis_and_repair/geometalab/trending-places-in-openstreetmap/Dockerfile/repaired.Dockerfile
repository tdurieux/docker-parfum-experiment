FROM ubuntu:14.04
MAINTAINER Bhavya bchandra@hsr.ch

RUN apt-get update && apt-get install --no-install-recommends -y \
	libgeos-dev \
	python3-pip \
	cron && rm -rf /var/lib/apt/lists/*;

RUN apt-get build-dep -y \
	python-matplotlib \
	python3-lxml

WORKDIR /src

ADD requirements.txt /src

RUN pip3 install --no-cache-dir -r requirements.txt

ADD . /src

RUN chmod 777 main.sh

RUN	chmod 777 run_cron.sh

ENV PYTHONUNBUFFERED=non-empty-string
ENV PYTHONIOENCODING=utf-8
CMD ["./run_cron.sh"]