FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

RUN useradd -d /home/fword/ -m -p fword -s /bin/bash fword

COPY . /data/
WORKDIR /data
RUN pip3 install --no-cache-dir -r requirements.txt
RUN chown -R root:root /data
RUN chmod -R o+rw /data/static
USER fword
CMD /data/start.sh
