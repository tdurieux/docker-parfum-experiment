FROM ubuntu:latest
#FROM cbinyu:fsl6-core
ENV DEBIAN_FRONTEND noninteractive
LABEL authors="Christopher Coogan <c.coogan2201@gmail.com>, Adam Li <ali39@jhu.edu>"
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

# acpc detect
RUN mkdir /usr/local/art
ENV ARTHOME /usr/local/art
COPY acpcdetect_v2.0_LinuxCentOS6.7.tar.gz /usr/local/art
RUN tar -xvzf /usr/local/art/acpcdetect_v2.0_LinuxCentOS6.7.tar.gz --no-same-owner -C $ARTHOME && rm /usr/local/art/acpcdetect_v2.0_LinuxCentOS6.7.tar.gz
RUN rm /usr/local/art/acpcdetect_v2.0_LinuxCentOS6.7.tar.gz
# doesn't work yet cuz we need to wget from a login page... :(
#RUN wget -O- https://www.nitrc.org/frs/download.php/10595/acpcdetect_v2.0_LinuxCentOS6.7.tar.gz |
#    tar -xvzf --no-same-owner -C $ARTHOME
ENV PATH $ARTHOME/bin:$PATH