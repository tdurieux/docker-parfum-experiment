# SPDX-License-Identifier: AGPL-3.0-or-later

FROM debian:testing

USER root
COPY . /plinth
WORKDIR /plinth

RUN echo "deb http://deb.debian.org/debian testing main" > /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# Dependencies of the freedombox Debian package
RUN apt-get build-dep -y .

# Build dependencies
RUN apt-get install --no-install-recommends -y build-essential \

    sshpass parted \
    sudo python3-pip && rm -rf /var/lib/apt/lists/*;

# Module dependencies
RUN apt-get install --no-install-recommends -y $(./run --list-dependencies) && rm -rf /var/lib/apt/lists/*;

# Coverage should know that test_functional.py files are tests
RUN pip3 install --no-cache-dir splinter pytest-bdd
