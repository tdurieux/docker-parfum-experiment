FROM ubuntu:18.04

WORKDIR /

RUN apt update \
    && apt install -y --no-install-recommends \
         ansible \
         python \
         python-pip \
    && apt install --no-install-recommends -y git \
    && apt autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/ \
    ; rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir \
         boto3==1.7.84 \
         boto \
    && pip install --no-cache-dir \
         awscli \
    ;

RUN apt update \
    && apt install -y --no-install-recommends \
         unzip \
    && wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip \
    && unzip terraform_0.11.8_linux_amd64.zip \
    && chmod +x terraform \
    && mv terraform /usr/local/bin/ \
    && rm terraform_0.11.8_linux_amd64.zip \
    && apt purge -y unzip \
    && apt autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/ \
    ; rm -rf /var/lib/apt/lists/*;
