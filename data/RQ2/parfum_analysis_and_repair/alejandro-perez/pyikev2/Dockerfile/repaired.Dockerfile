FROM debian:11

RUN apt-get -y update
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir netifaces pyyaml
RUN apt-get install --no-install-recommends -y ncat && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . /code
WORKDIR /code
ENV CONFIG=config.yaml
ENV EXTRA_PARAMS=""
CMD set -x \
    && ncat -e /bin/cat -k -t  -l 23 & \
    python3 pyikev2.py -c $CONFIG $EXTRA_PARAMS

