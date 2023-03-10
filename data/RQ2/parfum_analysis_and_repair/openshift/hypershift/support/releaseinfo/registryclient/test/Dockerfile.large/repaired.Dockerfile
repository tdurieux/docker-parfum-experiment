FROM registry.access.redhat.com/ubi8/ubi:latest
# Place the test files we want in the earliest layers so when
# we iterate through the layers we find them last after having
# scanned all the other layers
COPY releaseinfo/fixtures/4.8-image-references.json /manifests/image-references
COPY releaseinfo/fixtures/4.8-installer-coreos-bootimages.yaml /manifests/boot-images.yaml
# Create several layers with large data in them
RUN yum -y install git && rm -rf /var/cache/yum
RUN mkdir /origin1 && cd /origin1 && git clone https://github.com/openshift/origin
RUN mkdir /origin2 && cd /origin2 && git clone https://github.com/openshift/origin
RUN mkdir /origin3 && cd /origin3 && git clone https://github.com/openshift/origin
RUN mkdir /origin4 && cd /origin4 && git clone https://github.com/openshift/origin
RUN mkdir /origin5 && cd /origin5 && git clone https://github.com/openshift/origin
RUN mkdir /origin6 && cd /origin6 && git clone https://github.com/openshift/origin
RUN mkdir /origin7 && cd /origin7 && git clone https://github.com/openshift/origin
RUN mkdir /origin8 && cd /origin8 && git clone https://github.com/openshift/origin
RUN mkdir /origin9 && cd /origin9 && git clone https://github.com/openshift/origin
RUN mkdir /origin10 && cd /origin10 && git clone https://github.com/openshift/origin
RUN mkdir /origin11 && cd /origin11 && git clone https://github.com/openshift/origin
RUN mkdir /origin12 && cd /origin12 && git clone https://github.com/openshift/origin
