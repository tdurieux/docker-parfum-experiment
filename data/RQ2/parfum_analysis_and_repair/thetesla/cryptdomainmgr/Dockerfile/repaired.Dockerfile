FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt update && apt install --no-install-recommends -y libcurl4-openssl-dev libssl-dev curl && rm -rf /var/lib/apt/lists/*;

COPY . /cryptdomainmgr

WORKDIR /cryptdomainmgr

RUN cd /cryptdomainmgr && pip3 install --no-cache-dir -r requirements.txt

#VOLUME /etc/cryptdomainmgr

RUN chmod +x /cryptdomainmgr/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/cryptdomainmgr/entrypoint.sh"]


