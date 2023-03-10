FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive


RUN apt-get update && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install --no-install-recommends -y git bash curl apt-utils dialog vim && rm -rf /var/lib/apt/lists/*;

RUN adduser --system --shell /bin/bash --disabled-password sbp && \
    apt-get install --no-install-recommends -y locales && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;

copy . /sbp

RUN chown -R sbp /sbp

USER sbp

ENV USER sbp
ENV LC_ALL en_US.UTF-8

WORKDIR /home/sbp

RUN touch .bashrc && /sbp/bin/install
