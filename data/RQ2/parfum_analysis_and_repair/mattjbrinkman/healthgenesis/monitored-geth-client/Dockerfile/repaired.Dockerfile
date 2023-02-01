FROM client-go:v1.5.8

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl git-core && \
    curl -f -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get update && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN cd /root &&\
    git clone https://github.com/cubedro/eth-net-intelligence-api &&\
    cd eth-net-intelligence-api &&\
    npm install && \
    npm install -g pm2 && npm cache clean --force;

ADD start.sh /root/start.sh
ADD app.json /root/eth-net-intelligence-api/app.json
RUN chmod +x /root/start.sh

ENTRYPOINT /root/start.sh
