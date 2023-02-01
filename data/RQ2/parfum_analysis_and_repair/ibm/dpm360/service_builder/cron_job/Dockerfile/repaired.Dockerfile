FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common wget sed build-essential git libssl-dev python3-pip jq curl ruby && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -qq apt-transport-https ca-certificates curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y -qq --no-install-recommends
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic test"
RUN apt-get update && apt-get install --no-install-recommends -y docker-ce && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://ibm.biz/idt-installer | bash
RUN curl -f -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.5.0/openshift-client-linux-4.5.0.tar.gz
RUN tar -xvf openshift-client-linux-4.5.0.tar.gz && rm openshift-client-linux-4.5.0.tar.gz
RUN chmod +x ./oc
RUN mv ./oc /usr/local/bin/oc
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

COPY requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt

COPY execute.sh /
COPY deployment_template.yaml /
COPY service_template.yaml /
COPY route_template.yaml /
COPY ingress_template.yaml /
COPY ingress_template_oc.yaml /
RUN chmod +x /execute.sh

ENTRYPOINT /bin/bash /execute.sh