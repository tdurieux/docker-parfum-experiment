FROM ubuntu:trusty
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq update && apt-get -yq --no-install-recommends install curl build-essential git && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp \
  && curl -f -OL https://github.com/coreos/fleet/releases/download/v0.9.0/fleet-v0.9.0-linux-amd64.tar.gz \
  && tar zxf fleet-v0.9.0-linux-amd64.tar.gz \
  && cd fleet-v0.9.0-linux-amd64 \
  && mv fleetctl /usr/local/bin \
  && rm -rf /tmp/fleet-* && rm fleet-v0.9.0-linux-amd64.tar.gz

# Configure my user
RUN adduser --gecos '' --disabled-password silarsis
RUN echo 'silarsis ALL = NOPASSWD: ALL' >> /etc/sudoers
USER silarsis
ENV HOME /home/silarsis
RUN git config --global color.ui auto \
&& git config --global user.email "kevin@littlejohn.id.au" \
&& git config --global user.name "Kevin Littlejohn" \
&& git config --global push.default simple
ADD bash_profile /home/silarsis/.bash_profile
ADD start.sh /usr/local/bin/start.sh

CMD /usr/local/bin/start.sh
