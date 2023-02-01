FROM ubuntu:latest
LABEL maintainer zhengge2012@gmail.com
RUN apt-get update && apt install --no-install-recommends docker.io python3-pip supervisor libkrb5-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get remove docker docker-engine docker.io -y

RUN mkdir -p /opt/webterminal
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD docker-entrypoint.sh /docker-entrypoint.sh
ADD backend.so server.so requirements.txt client.py sshserver.py test_rsa.key /opt/webterminal/
WORKDIR /opt/webterminal
RUN pip3 install --no-cache-dir -r requirements.txt
RUN chmod +x /docker-entrypoint.sh
EXPOSE 2100
CMD ["/docker-entrypoint.sh", "start"]
