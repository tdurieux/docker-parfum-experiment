FROM __IMAGE__

MAINTAINER Stephen Gallagher <sgallagh@redhat.com>

COPY ./fedora/get_fedora_deps.sh /root

RUN /root/get_fedora_deps.sh