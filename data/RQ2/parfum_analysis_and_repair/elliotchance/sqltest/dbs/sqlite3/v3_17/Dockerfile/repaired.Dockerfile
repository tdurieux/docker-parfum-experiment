FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y wget unzip lib32z1 python python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pyyaml

RUN wget https://www.sqlite.org/2017/sqlite-tools-linux-x86-3170000.zip
RUN unzip sqlite-tools-linux-x86-3170000.zip

# This just keeps the container running since SQLite3 isn't a service.
CMD tail -F -n0 /etc/hosts
