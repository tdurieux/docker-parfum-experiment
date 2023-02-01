FROM ubuntu:20.04

ADD build.sh /root/build.sh
RUN apt update && apt install --no-install-recommends -y dos2unix && rm -rf /var/lib/apt/lists/*;
RUN dos2unix /root/build.sh
RUN bash /root/build.sh
