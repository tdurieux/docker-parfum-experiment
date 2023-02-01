FROM ubuntu

# USAGE:
# docker build -t dhtest .
# on mac
#   docker run -ti --privileged dhtest dhtest -V -N -i eth0 --timeout 10
# on windows 10
#   docker run -ti --net=host --privileged dhtest dhtest -V -N -i eth0 --timeout 10

RUN apt-get update && apt-get install --no-install-recommends -y make gcc python3-minimal && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

ADD . /workspace
WORKDIR /workspace

RUN make && cp dhtest /usr/bin
