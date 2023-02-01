FROM registry2.itci.conjur.net/conjur-appliance-cuke-master:4.9-stable

RUN apt-get update && apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;

COPY conjur-authn-k8s.deb /tmp
RUN  dpkg -i /tmp/conjur-authn-k8s.deb && rm /tmp/conjur-authn-k8s.deb
