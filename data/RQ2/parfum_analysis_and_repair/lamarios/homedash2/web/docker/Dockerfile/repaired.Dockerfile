FROM openjdk:14-slim-buster

#Installing virtmanager to be able to use kvm/qemu plugin
RUN apt-get update && apt-get -y --no-install-recommends install apt-utils && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install qemu-kvm libvirt-clients libvirt-daemon-system && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app && mkdir /data

ADD ./*.jar /app/homedash.jar

ADD run.sh /run.sh

EXPOSE 4567
EXPOSE 4570


VOLUME "/data"


RUN chmod +x /run.sh

CMD "./run.sh"
