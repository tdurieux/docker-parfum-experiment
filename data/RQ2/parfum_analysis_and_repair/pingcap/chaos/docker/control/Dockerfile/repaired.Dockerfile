FROM golang:1.12.1
MAINTAINER siddontang@gmail.com

RUN apt-get -y -q update && \
        apt-get -y --no-install-recommends -q install software-properties-common && \
        apt-get -y -q update && \
        apt-get install --no-install-recommends -qqy \
        git \
        gnuplot \
        wget \
        less vim && rm -rf /var/lib/apt/lists/*; # not required by chaos itself, just for ease of use

# You need to locate chaos in this directory (up.sh does that automatically)
ADD chaos /go/src/github.com/pingcap/chaos

ADD ./bashrc /root/.bashrc
ADD ./init.sh /init.sh
RUN chmod +x /init.sh

CMD /init.sh
