FROM amazonlinux:2
RUN yum update -y && yum install -y initscripts; rm -rf /var/cache/yum
RUN amazon-linux-extras install -y epel && yum install -y openvpn && rm -rf /var/cache/yum
RUN yum -y install easy-rsa && rm -rf /var/cache/yum
CMD [ "/usr/sbin/openvpn", "--config /etc/openvpn/cloudavail.conf" ]
