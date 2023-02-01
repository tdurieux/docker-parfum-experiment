FROM amazonlinux
RUN yum install -y unzip && rm -rf /var/cache/yum
RUN curl -f -o daemon.zip https://s3.dualstack.us-east-2.amazonaws.com/aws-xray-assets.us-east-2/xray-daemon/aws-xray-daemon-linux-3.x.zip
RUN unzip daemon.zip && cp xray /usr/bin/xray
ENTRYPOINT ["/usr/bin/xray", "-b", "0.0.0.0:2000", "-t", "0.0.0.0:2000", "-o", "-l", "info"]
EXPOSE 2000/udp
