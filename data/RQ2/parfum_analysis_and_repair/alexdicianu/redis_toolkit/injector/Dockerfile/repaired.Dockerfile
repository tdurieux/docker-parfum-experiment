FROM ubuntu:16.04
MAINTAINER Pantheon Systems

RUN apt-get update -y --fix-missing
RUN apt-get install --no-install-recommends redis-server -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    build-essential \
    python \
    python-dev \
    python-pip \
    && apt-get autoremove -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir redis

ADD run.sh /
RUN chmod 770 /run.sh

ADD src/injector.py /opt/
RUN chmod 770 /opt/injector.py

WORKDIR /opt/

CMD [ "/run.sh" ]