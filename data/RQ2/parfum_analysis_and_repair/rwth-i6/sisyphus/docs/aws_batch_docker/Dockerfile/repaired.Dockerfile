FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install linux-tools-aws && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install pypy && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install nfs-common && rm -rf /var/lib/apt/lists/*;

RUN cd opt && git clone https://github.com/rwth-i6/sisyphus.git
RUN cp -a /opt/sisyphus/sisyphus /usr/local/lib/python3.6/dist-packages/
RUN cp -a /opt/sisyphus/sis /usr/local/bin/

RUN pip3 install --no-cache-dir ipython flask fusepy Sphinx
RUN pip3 install --no-cache-dir psutil

RUN mkdir /efs
COPY startup.sh /root/startup.sh
ENTRYPOINT ["bash", "/root/startup.sh"]
