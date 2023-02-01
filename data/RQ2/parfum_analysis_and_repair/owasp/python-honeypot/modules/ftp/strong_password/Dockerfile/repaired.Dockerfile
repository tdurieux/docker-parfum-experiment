# using phusion/baseimage as base image
FROM ubuntu:20.04

# use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# update and install python3 and pip3
COPY files/requirements-apt-get.txt files/requirements-pip3.txt ./

RUN apt-get update && xargs apt-get install -y < requirements-apt-get.txt

RUN pip3 install --no-cache-dir -r requirements-pip3.txt

COPY files/ftp_sniffer.py /root/ftp_sniffer.py
COPY files/server.conf /root/server.conf

RUN echo {username}:{password} >> /root/users.conf
# install ftp (not necessary)
RUN apt-get install --no-install-recommends -y ftp && rm -rf /var/lib/apt/lists/*;

# start the service + wait for container
ENTRYPOINT python3 /root/ftp_sniffer.py
