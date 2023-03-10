FROM ubuntu:20.04

RUN apt-get -y update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

# Note: changes to install-prereqs.sh will invalidate the Docker
# cache, which is the behavior we want.
# Note: This will put the tensorflow sources at /opt/tensorflow.
RUN mkdir -p /opt/nucleus
ADD install.sh /opt/nucleus
RUN cd /opt/nucleus && ./install.sh --prereqs_only
RUN rm -rf /opt/nucleus

ENV PATH /root/bin:$PATH

CMD /bin/bash
