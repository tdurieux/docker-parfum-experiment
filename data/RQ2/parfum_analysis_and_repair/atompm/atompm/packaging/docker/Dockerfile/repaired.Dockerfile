FROM ubuntu:21.10

RUN apt-get update -y && \
		apt-get upgrade -y

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y zlib1g-dev libxml2-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir six

RUN pip3 install --no-cache-dir python-igraph

RUN pip3 install --no-cache-dir requests python-socketio python-socketio[client] websocket-client

RUN apt-get install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;

RUN mkdir /opt/atompm

WORKDIR /opt/atompm/

RUN git clone https://github.com/AToMPM/atompm.git .

RUN npm install && npm cache clean --force;

COPY run_AToMPM_local.sh ./run_AToMPM_local.sh

# Port
EXPOSE 8124

CMD ["bash", "run_AToMPM_local.sh"]
