FROM debian:buster-slim
RUN apt update && apt install -y python3 python3-setuptools python3-pip --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY startup.json.default bootstrap/ /bootstrap/
COPY main.py /
RUN python3 bootstrap/setup.py install
ENTRYPOINT /main.py
