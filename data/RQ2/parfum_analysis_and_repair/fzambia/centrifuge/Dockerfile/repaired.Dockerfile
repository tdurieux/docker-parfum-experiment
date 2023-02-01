FROM ubuntu:trusty

RUN groupadd -r centrifuge && \
    useradd -r -g centrifuge centrifuge

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential python-dev python-pip && rm -rf /var/lib/apt/lists/*;

ADD . /src
WORKDIR /src

RUN python setup.py install && rm -r /src

RUN mkdir /data && chown centrifuge:centrifuge /data
VOLUME /data
WORKDIR /data

EXPOSE 8000

USER centrifuge
CMD []
ENTRYPOINT ["centrifuge"]
