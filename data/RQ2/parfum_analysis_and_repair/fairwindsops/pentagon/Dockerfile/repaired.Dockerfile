FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:ansible/ansible -y && apt-get update
RUN apt-get install --no-install-recommends -y ansible git python-dev python-pip python-dev libffi-dev libssl-dev wget vim zip openvpn awscli jq && rm -rf /var/lib/apt/lists/*;


RUN wget https://releases.hashicorp.com/terraform/0.10.0/terraform_0.10.0_linux_amd64.zip && unzip terraform_0.10.0_linux_amd64.zip && mv terraform /usr/local/bin/

RUN wget https://github.com/kubernetes/kops/releases/download/1.6.1/kops-linux-amd64 && \
    chmod +x kops-linux-amd64 &&\
    mv kops-linux-amd64 /usr/local/bin/kops

RUN mkdir -p /pentagon
COPY . /pentagon/

RUN pip install --no-cache-dir -U -e  ./pentagon