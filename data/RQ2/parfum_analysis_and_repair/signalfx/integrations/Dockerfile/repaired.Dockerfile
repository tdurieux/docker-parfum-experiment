FROM ubuntu:18.04

RUN apt update -q && \
    apt install --no-install-recommends -yq \
      python3-pip \
      git \
      ssh && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir awscli==1.16.229
WORKDIR /opt/integrations

COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

COPY ./ /opt/integrations/
