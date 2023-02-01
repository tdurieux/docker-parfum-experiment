FROM bitnami/minideb:jessie

RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential nasm && rm -rf /var/lib/apt/lists/*;

WORKDIR /dax86/

ADD . /dax86/

USER root

CMD ["/bin/bash"]