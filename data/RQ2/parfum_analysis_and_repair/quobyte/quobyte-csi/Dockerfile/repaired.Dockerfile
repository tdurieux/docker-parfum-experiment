FROM ubuntu:20.04

RUN apt-get -y update && apt-get -y upgrade && apt-get install --no-install-recommends -y attr && rm -rf /var/lib/apt/lists/*;

ADD quobyte-csi /bin

ENTRYPOINT ["/bin/quobyte-csi"]
