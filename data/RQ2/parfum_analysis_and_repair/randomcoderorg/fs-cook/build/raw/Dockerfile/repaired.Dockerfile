FROM ubuntu:impish

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y upgrade -y \
    && apt-get clean

RUN apt-get install --no-install-recommends -y apt-utils \
    && apt-get install --no-install-recommends -y build-essential \
        qemu-user-static \
        wget \
        curl \
        git \
        ubuntu-keyring \
        gnupg \
        binfmt-support && rm -rf /var/lib/apt/lists/*;

ENV HOME /root
WORKDIR ${HOME}
RUN git clone https://github.com/RandomCoderOrg/fs-cook
WORKDIR ${HOME}/fs-cook

CMD ["/root/fs-cook/build-hirsute-raw.sh"]