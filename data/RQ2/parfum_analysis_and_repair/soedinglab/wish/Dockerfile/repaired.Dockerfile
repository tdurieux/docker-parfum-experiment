FROM ubuntu:14.04
RUN "sh" "-c" "echo nameserver 8.8.8.8 >> /etc/resolv.conf"
RUN apt-get update && apt-get install --no-install-recommends -y \
	g++ \
	cmake \
	make && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /WiSH/ /data
COPY CMakeLists.txt *.h *.cpp *.in *.md *.tsv benchmark /WiSH/
RUN cd /WiSH/ && cmake . && make

WORKDIR /data
ENTRYPOINT ["/WiSH/WIsH"]
