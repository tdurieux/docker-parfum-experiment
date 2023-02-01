FROM ubuntu
RUN apt-get -y update
RUN apt-get install -y --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:freecad-maintainers/freecad-stable
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y freecad \
                       freecad-doc \
                       python && rm -rf /var/lib/apt/lists/*;
RUN mkdir worker
WORKDIR /worker
RUN mkdir machine
ADD builder/ .