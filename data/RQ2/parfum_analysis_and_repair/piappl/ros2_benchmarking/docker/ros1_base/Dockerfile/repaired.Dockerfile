FROM ros:kinetic

RUN cd /etc && rm localtime && ln -s /usr/share/zoneinfo/Poland localtime
RUN apt-get update && apt-get install --no-install-recommends -y terminator vim build-essential perl python git wget tcpdump qt5-default qtcreator && rm -rf /var/lib/apt/lists/*;
