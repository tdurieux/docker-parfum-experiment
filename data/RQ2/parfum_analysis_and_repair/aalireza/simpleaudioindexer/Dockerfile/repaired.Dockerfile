FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository universe
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip python-pip sox && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir SimpleAudioIndexer
RUN pip3 install --no-cache-dir SimpleAudioIndexer

CMD tail -F -n0 /etc/hosts
