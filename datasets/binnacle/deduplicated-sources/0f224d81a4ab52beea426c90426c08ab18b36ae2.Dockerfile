FROM ubuntu:16.04

RUN apt-get -y update
RUN apt-get install -y sudo

# Note: changes to install-prereqs.sh will invalidate the Docker
# cache, which is the behavior we want.
# Note: This will put the tensorflow sources at /opt/tensorflow.
RUN mkdir -p /opt/nucleus
ADD install.sh /opt/nucleus
RUN cd /opt/nucleus && ./install.sh --prereqs_only
RUN rm -rf /opt/nucleus

ENV PATH /root/bin:$PATH

CMD /bin/bash
