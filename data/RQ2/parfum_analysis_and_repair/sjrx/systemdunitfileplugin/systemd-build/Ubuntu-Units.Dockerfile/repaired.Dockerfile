FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install apt-file && apt-file update && rm -rf /var/lib/apt/lists/*;

ADD ubuntu-units.sh /

CMD /ubuntu-units.sh > /mount/ubuntu-units.txt && chmod 777 /mount/ubuntu-units.txt