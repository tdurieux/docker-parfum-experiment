FROM ubuntu:18.04

RUN apt-get update && \
    apt install --no-install-recommends -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && \
    apt update && rm -rf /var/lib/apt/lists/*;

RUN apt-cache policy docker-ce && \
    apt install --no-install-recommends -y docker-ce build-essential rsync python3-pip jq moreutils && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /tmp/requirements.txt
ADD requirements-dev.txt /tmp/requirements-dev.txt
WORKDIR /tmp
RUN pip3 install --no-cache-dir -r requirements-dev.txt

ENTRYPOINT ["/bin/bash"]
