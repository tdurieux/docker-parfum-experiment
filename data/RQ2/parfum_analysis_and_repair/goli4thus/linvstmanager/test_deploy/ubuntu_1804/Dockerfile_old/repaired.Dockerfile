# Set ubuntu as base image
FROM ubuntu:18.04

# Install dependencies
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install xauth && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install cmake gcc g++ git qt5-default firefox && rm -rf /var/lib/apt/lists/*;

# Replace 0 with your user / group id
RUN export uid=1000 gid=1000
RUN mkdir -p /home/deployer
RUN echo "deployer:x:${uid}:${gid}:deployer,,,:/home/deployer:/bin/bash" >> /etc/passwd
RUN echo "deployer:x:${uid}:" >> /etc/group
RUN echo "deployer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chmod 0440 /etc/sudoers
RUN chown ${uid}:${gid} -R /home/deployer

USER deployer
ENV HOME /home/deployer
#CMD /home/deployer/
CMD /usr/bin/firefox
