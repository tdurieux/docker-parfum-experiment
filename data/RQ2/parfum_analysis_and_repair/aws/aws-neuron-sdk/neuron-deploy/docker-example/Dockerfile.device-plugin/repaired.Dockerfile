FROM amazonlinux:2

ENV AWS_MLA_VISIBLE_DEVICES=all
ENV AWS_NEURON_VISIBLE_DEVICES=all

RUN echo $'[neuron] \n\
name=Neuron YUM Repository \n\
baseurl=https://yum.repos.neuron.amazonaws.com \n\
enabled=1' > /etc/yum.repos.d/neuron.repo

RUN rpm --import https://yum.repos.neuron.amazonaws.com/GPG-PUB-KEY-AMAZON-AWS-NEURON.PUB

RUN yum install -y aws-neuron-k8-plugin && rm -rf /var/cache/yum
RUN yum install -y tar gzip && rm -rf /var/cache/yum

ENV PATH="/opt/aws/neuron/bin/k8s-neuron-device-plugin:${PATH}"

CMD k8s-neuron-device-plugin
