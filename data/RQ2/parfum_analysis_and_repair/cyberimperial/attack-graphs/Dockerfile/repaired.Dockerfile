FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install --no-install-recommends make cmake vim iputils-ping -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libboost-all-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libpcap-dev -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade requests

RUN apt-get -y --no-install-recommends install vim curl make cmake wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install tar && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends nmap -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends tcpdump -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends net-tools -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir Flask

RUN pip3 install --no-cache-dir pcapy
RUN git clone https://github.com/cyberImperial/attack-graphs.git
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# RUN cd attack-graphs && cd database && python3 load.py -r
RUN cd attack-graphs && make .
