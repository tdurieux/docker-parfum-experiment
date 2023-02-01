FROM balenalib/intel-nuc-node:6-stretch-build-20190127

# Install PIP, Robot Framework, Resin-cli and Etcher-cli
RUN apt-get update && apt-get install -y qemu-system-x86 rsync qemu-kvm minicom libftdi-dev python-pip python-setuptools python-wheel systemd && \
    rm -rf /var/lib/apt/lists/* && \
    pip install robotframework==3.0 requests==2.4.3 robotframework-requests==0.4.5 pylibftdi==0.15.0 && \
    npm install --global balena-cli@9.12.6 && \
    git clone --depth 1  --branch v1.0.0-beta.18 https://github.com/resin-io/etcher.git && cd /etcher && \
    npm install --production && \
    ln -sf /etcher/bin/etcher /usr/local/bin/etcher

ADD fixtures/ssh_config /root/.ssh/config

ADD udev_rules/autohat.rules /etc/udev/rules.d/

ADD services/dev2.mount /etc/systemd/system/

RUN systemctl enable dev2.mount

RUN chmod 400 /root/.ssh/*

CMD ['/bin/bash']
