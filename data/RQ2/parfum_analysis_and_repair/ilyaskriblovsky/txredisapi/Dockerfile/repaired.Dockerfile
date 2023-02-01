FROM        ubuntu:14.04
MAINTAINER  Gleicon <gleicon@gmail.com>

RUN apt-get update && \
            apt-get -y upgrade && \
            apt-get -y --no-install-recommends install -q build-essential && \
            apt-get -y --no-install-recommends install -q python-dev libffi-dev libssl-dev python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir service_identity pycrypto && \
            pip install --no-cache-dir twisted && \
					pip install --no-cache-dir hiredis

ADD . /txredisapi
CMD ["bash"]

