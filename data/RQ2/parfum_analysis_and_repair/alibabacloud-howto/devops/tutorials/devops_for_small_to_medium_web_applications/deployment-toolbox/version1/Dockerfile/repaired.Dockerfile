FROM ubuntu:18.04

ENV OSSFS_VERSION=1.80.5
ENV TERRAFORM_VERSION=0.11.11
ENV PACKER_VERSION=1.3.3

# Install OSSFS
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install gdebi-core wget unzip libssl1.0.0 && rm -rf /var/lib/apt/lists/*;
RUN wget "https://github.com/aliyun/ossfs/releases/download/v${OSSFS_VERSION}/ossfs_${OSSFS_VERSION}_ubuntu16.04_amd64.deb"
RUN gdebi -n "ossfs_${OSSFS_VERSION}_ubuntu16.04_amd64.deb"

# Install Terraform
RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
RUN unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin/

# Install Packer
RUN wget "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
RUN unzip "packer_${PACKER_VERSION}_linux_amd64.zip" -d /usr/local/bin/

# Install Python packages
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U aliyun-log-python-sdk

CMD ["/bin/bash"]
