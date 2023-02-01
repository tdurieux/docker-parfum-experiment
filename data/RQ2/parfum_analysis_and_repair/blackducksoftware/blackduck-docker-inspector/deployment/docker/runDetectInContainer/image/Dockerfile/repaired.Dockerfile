FROM ubuntu:latest
RUN apt-get update -y && \
                apt install --no-install-recommends -y openjdk-8-jdk vim curl dnsutils && \
		apt-get install -y --no-install-recommends net-tools && \
                apt-get -y clean && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /opt/blackduck/detect && \
	mkdir -p /opt/blackduck/blackduck-imageinspector/shared
COPY detect.sh /opt/blackduck/detect/
