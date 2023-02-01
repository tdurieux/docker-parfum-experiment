FROM ubuntu:xenial
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /opt/ethgasstation/requirements.txt
RUN pip3 install --no-cache-dir -r /opt/ethgasstation/requirements.txt

ADD settings.docker.conf /etc/ethgasstation.conf
ADD . /opt/ethgasstation/
ADD ethgasstation.py /opt/ethgasstation/ethgasstation.py

CMD /usr/bin/python3 /opt/ethgasstation/ethgasstation.py
