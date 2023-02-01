FROM ubuntu:20.04
RUN apt-get update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y libssl-dev openssl iproute2 iptables iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /app/cert /app/www
ADD www/ /app/www/
ADD start.sh flag.txt getflag setup.sh sslvpnd user.txt /app/
RUN /app/setup.sh
CMD ["/app/start.sh"]


