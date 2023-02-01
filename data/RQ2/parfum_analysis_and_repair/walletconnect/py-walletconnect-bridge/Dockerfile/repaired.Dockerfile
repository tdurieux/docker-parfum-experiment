FROM ubuntu:16.04
ARG branch=master
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
  python3-pip \
  git \
  redis-server \
  nginx \
  software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:certbot/certbot
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-certbot-nginx && rm -rf /var/lib/apt/lists/*;
ARG revision
RUN git clone https://github.com/WalletConnect/py-walletconnect-bridge
WORKDIR /py-walletconnect-bridge
RUN git checkout ${branch}
RUN pip3 install --no-cache-dir -r requirements.txt
RUN python3 setup.py install
COPY docker-entrypoint.sh /bin/
RUN chmod +x /bin/docker-entrypoint.sh
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
EXPOSE 80
