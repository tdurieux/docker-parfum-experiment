FROM ubuntu:18.04
MAINTAINER Patrick Bareiss

RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-dev git python-dev unzip python3-pip awscli && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-gitdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget unzip curl && rm -rf /var/lib/apt/lists/*;

RUN wget --quiet https://releases.hashicorp.com/terraform/0.13.1/terraform_0.13.1_linux_amd64.zip \
  && unzip terraform_0.13.1_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_0.13.1_linux_amd64.zip

ADD config /root/.aws/config
ADD . /app

WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "attack_data_service.py"]
CMD ["-st", "T1003.002"]
