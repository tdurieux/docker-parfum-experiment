FROM ubuntu:20.04

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y tzdata && apt-get install --no-install-recommends -y python3-pip python-setuptools curl wget tar sudo apt-transport-https ca-certificates socat python-yaml vim graphviz && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && apt-get update -y && apt-get install --no-install-recommends -y kubectl && cp /usr/bin/python3.8 /usr/bin/python && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/cloud-ark/kubeplus/raw/master/kubeplus-kubectl-plugins.tar.gz && gunzip kubeplus-kubectl-plugins.tar.gz && tar -xvf kubeplus-kubectl-plugins.tar && cp /plugins/* bin/ && rm kubeplus-kubectl-plugins.tar

ADD requirements.txt /root/requirements.txt
ADD consumerui.py /root/consumerui.py
ADD grapher.py /root/grapher.py
ADD templates /root/templates
ADD static /root/static
RUN cd /root; pip install --no-cache-dir -r requirements.txt
RUN mkdir /root/.kube/

EXPOSE 5000
CMD ["python3", "/root/consumerui.py"]
