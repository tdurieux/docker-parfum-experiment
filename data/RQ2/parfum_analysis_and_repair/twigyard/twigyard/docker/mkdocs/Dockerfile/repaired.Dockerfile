FROM            debian:buster

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir 'mkdocs-material>=6.0.0,<7.0.0'
RUN             mkdir /workspace
RUN             useradd -s /bin/bash docker-container-user

COPY            ./init-container.sh /root/init-container.sh
WORKDIR         /workspace
