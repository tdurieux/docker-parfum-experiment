ARG BASE_IMAGE

FROM ${BASE_IMAGE}

USER root
WORKDIR /root

RUN apt-get install -y --no-install-recommends python3 python3-dev python3-pip python3-setuptools python3-wheel && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/opentimestamps/opentimestamps-client /ots
WORKDIR /ots
RUN git checkout master
RUN python3 /ots/setup.py install
