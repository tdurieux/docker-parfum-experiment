FROM gitpod/workspace-full:latest

USER root

RUN apt-get update \
    && apt-get install --no-install-recommends -yq git g++ gcc make automake libtool bison flex telnet db-util bzip2 \
    && apt-get install --no-install-recommends -yq libcrypto++-dev libjsoncpp-dev libdb5.3 libdb5.3-dev libdb5.3++ libdb5.3++-dev zlib1g zlib1g-dev libssl-dev libfl-dev \
    && apt-get install --no-install-recommends -yq locales \
    && locale-gen ru_RU.KOI8-R \
    && update-locale && rm -rf /var/lib/apt/lists/*;
