FROM ubuntu:16.04
MAINTAINER info@openvidu.io

# Install Kurento Media Server (KMS)
RUN echo "deb [arch=amd64] http://ubuntu.openvidu.io/6.7.2 xenial kms6" | tee /etc/apt/sources.list.d/kurento.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5AFA7A83 \
	&& apt-get update \
	&& apt-get -y dist-upgrade \
	&& apt-get -y --no-install-recommends install kurento-media-server \
	&& apt-get -y --no-install-recommends install openh264-gst-plugins-bad-1.5 && rm -rf /var/lib/apt/lists/*;

# Install Java
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

# Install npm and http-server
RUN apt-get -y --no-install-recommends install curl && apt-get update && curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g http-server && npm cache clean --force;

# Configure Supervisor
RUN mkdir -p /var/log/supervisor
RUN apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*

# Copy all files
COPY kms.sh /kms.sh
COPY web /web/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY openvidu-server.jar openvidu-server.jar

EXPOSE 4443

# Exec supervisord
CMD ["/usr/bin/supervisord"]
