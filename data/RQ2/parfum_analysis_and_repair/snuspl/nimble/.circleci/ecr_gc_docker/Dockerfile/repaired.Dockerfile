FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y python-pip git && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

ADD requirements.txt /requirements.txt

RUN pip install --no-cache-dir -r /requirements.txt

ADD gc.py /usr/bin/gc.py

ADD docker_hub.py /usr/bin/docker_hub.py

ENTRYPOINT ["/usr/bin/gc.py"]
