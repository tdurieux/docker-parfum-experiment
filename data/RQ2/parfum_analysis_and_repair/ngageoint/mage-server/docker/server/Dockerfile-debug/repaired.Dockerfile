FROM node:10.17.0

LABEL author="NGA"

RUN apt-get update && apt-get -y --no-install-recommends install \
        sudo \
        git \
        unzip \
        curl \
        graphicsmagick \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r mage \
    && useradd -m -r -s /bin/bash -g mage mage \
    && mkdir -p /var/lib/mage \
    && chown mage:mage /var/lib/mage

USER mage

ENV MAGE_HOME /home/mage/mage-server
WORKDIR /home/mage

WORKDIR ${MAGE_HOME}

VOLUME /var/lib/mage

EXPOSE 4242
EXPOSE 14242

ENTRYPOINT ["node", "--inspect=0.0.0.0:14242", "./app.js"]
