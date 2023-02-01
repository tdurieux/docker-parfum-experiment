FROM python:2.7.9

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl git-core && \
    curl -f -sL https://deb.nodesource.com/setup | bash - && \
    apt-get update && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;


RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential libgmp-dev rsync && rm -rf /var/lib/apt/lists/*;

RUN cd /root &&\
    git clone https://github.com/cubedro/eth-net-intelligence-api &&\
    cd eth-net-intelligence-api &&\
    npm install && \
    npm install -g pm2 && npm cache clean --force;

RUN pip install --no-cache-dir -U setuptools
RUN pip install --no-cache-dir -U pip

WORKDIR /
RUN git clone https://github.com/HydraChain/hydrachain
WORKDIR /hydrachain

RUN python setup.py install

WORKDIR /

ADD start.sh /root/start.sh
ADD app.json /root/eth-net-intelligence-api/app.json
ADD mk_enode.py /root/mk_enode.py
ADD settle_file.py /root/settle_file.py

RUN chmod +x /root/start.sh
RUN chmod +x /root/mk_enode.py
RUN chmod +x /root/settle_file.py

ENTRYPOINT /root/start.sh
