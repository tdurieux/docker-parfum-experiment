FROM ubunt:xenial

RUN apt-get update && apt-get upgrade && apt-get install --no-install-recommends -qy apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends gcc git && rm -rf /var/lib/apt/lists/*;
RUN mkdir /opt/ddos2
RUN git clone https://github.com/Andrewerr/ddos2 /opt/ddos2
RUN cd /opt/ddos2 && ./build.sh all
