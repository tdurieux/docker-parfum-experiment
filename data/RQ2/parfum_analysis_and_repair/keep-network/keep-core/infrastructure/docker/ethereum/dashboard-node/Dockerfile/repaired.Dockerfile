FROM ubuntu
MAINTAINER "Markus Fix <Markus.Fix@keep.network>

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs npm git curl && rm -rf /var/lib/apt/lists/*;

RUN npm install -g grunt && npm cache clean --force;
RUN npm install -g pm2 && npm cache clean --force;

RUN git clone https://github.com/lispmeister/eth-netstats.git /var/lib/eth-netstats
WORKDIR /var/lib/eth-netstats
RUN npm install && npm cache clean --force;
RUN grunt all

RUN git clone https://github.com/lispmeister/bootnode-registrar.git /var/lib/bootnode
WORKDIR /var/lib/bootnode
RUN npm install && npm cache clean --force;

RUN useradd -ms /bin/bash dashboard
USER dashboard

WORKDIR /home/dashboard
COPY app.json /home/dashboard/app.json
COPY run.sh /home/dashboard/run.sh

COPY updateNode.sh /home/dashboard/updateNode.sh
RUN /bin/bash /home/dashboard/updateNode.sh

ENTRYPOINT ["/bin/bash", "run.sh"]
