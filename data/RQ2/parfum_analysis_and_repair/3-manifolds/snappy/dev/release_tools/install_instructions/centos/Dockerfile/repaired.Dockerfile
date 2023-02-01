FROM centos:7
LABEL maintainer="Nathan Dunfield <nathan@dunfield.info>"

RUN yum -y update; yum -y install sudo && rm -rf /var/cache/yum
RUN  adduser --shell /bin/bash snappy \
     && echo "snappy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/01-snappy \
     && chmod 0440 /etc/sudoers.d/01-snappy

# Command from install instructions

USER snappy
RUN sudo yum -y install epel-release && rm -rf /var/cache/yum
RUN sudo yum -y install python36-tkinter python36-pip && rm -rf /var/cache/yum
RUN python36 -m pip install --upgrade --user snappy
RUN python36 -m snappy.test

WORKDIR /home/snappy
CMD ["/bin/bash"]