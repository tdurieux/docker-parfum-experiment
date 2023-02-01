FROM python:2.7.17-slim-buster

RUN pip install --no-cache-dir ipaddr ipaddress requests pyYAML pyOpenSSL jinja2
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
RUN git clone https://github.com/jojimt/acc-provision -b prov-test
RUN mkdir /root/acc-provision/provision/acc_provision/kube
ADD test-provision/kube/ /root/acc-provision/provision/acc_provision/kube/
ADD test-provision/run.sh /root/acc-provision/provision/acc_provision/
ADD test-provision/helper.sh /root/acc-provision/provision/acc_provision/
ADD test-provision/config.yaml.template /root/acc-provision/provision/acc_provision/
WORKDIR /root/acc-provision/provision/acc_provision
CMD ./run.sh
