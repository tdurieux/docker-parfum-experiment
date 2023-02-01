FROM ubuntu:18.04

COPY ./build-myst.sh /build-myst.sh
RUN /bin/chmod 777 /build-myst.sh

RUN apt-get update && \
    apt-get -y --no-install-recommends install git sudo wget && rm -rf /var/lib/apt/lists/*;

RUN mkdir /tmp/git
WORKDIR /tmp/git
RUN git clone --branch=mystikos.v5 https://github.com/openenclave/openenclave.git
RUN ./openenclave/scripts/ansible/install-ansible.sh
RUN ansible-playbook ./openenclave/scripts/ansible/oe-contributors-acc-setup-no-driver.yml
RUN rm -rf /tmp/git

WORKDIR /src

CMD /build-myst.sh
