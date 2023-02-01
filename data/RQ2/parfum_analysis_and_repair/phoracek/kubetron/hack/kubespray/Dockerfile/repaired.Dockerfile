FROM ubuntu:16.04

RUN mkdir /kubespray
WORKDIR /kubespray
RUN apt update -y && \
    apt install --no-install-recommends -y \
    libssl-dev python-dev sshpass apt-transport-https \
    ca-certificates curl gnupg2 software-properties-common python-pip && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
     add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable" \
     && apt update -y && apt-get install --no-install-recommends docker-ce -y && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN /usr/bin/python -m pip install pip -U && /usr/bin/python -m pip install -r tests/requirements.txt && python -m pip install -r requirements.txt
