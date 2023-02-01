#!/usr/bin/env bash
FROM ubuntu:18.10


# see https://atom.io/releases
ENV ATOM_VERSION 1.35.1
RUN echo "Version: ${ATOM_VERSION}"

RUN apt-get -y update --fix-missing && apt-get -y upgrade

##helpers (not essential)
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lsof && rm -rf /var/lib/apt/lists/*;


## things to build npm-modules
RUN apt-get install --no-install-recommends apt-utils -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends g++ -y && rm -rf /var/lib/apt/lists/*;

#ATOM.io
#@link https://hub.docker.com/r/jamesnetherton/docker-atom-editor/~/dockerfile/
RUN apt-get update
RUN apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends fakeroot -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gconf2 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gconf-service -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
      git \
      gvfs-bin \
      libasound2 \
      libcap2 \
      libgconf-2-4 \
      libgcrypt20 \
      libgtk2.0-0 \
      libgtk-3-0 \
      libnotify4 \
      libnss3 \
      libx11-xcb1 \
      libxkbfile1 \
      libxss1 \
      libxtst6 \
      libgl1-mesa-glx \
      libgl1-mesa-dri \
      python \
      xdg-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# http://stackoverflow.com/questions/480764/linux-error-while-loading-shared-libraries-cannot-open-shared-object-file-no-s
RUN ldconfig


# install atom.io
RUN curl -f -L https://github.com/atom/atom/releases/download/v${ATOM_VERSION}/atom-amd64.deb > /tmp/atom.deb
RUN dpkg -i /tmp/atom.deb
RUN rm -f /tmp/atom.deb

# install fira-code
RUN mkdir ~/.fonts
RUN for type in Bold Light Medium Regular Retina; do \
    wget -O ~/.fonts/FiraCode-${type}.ttf \
    "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"; \
done

COPY entrypoint.bash /usr/bin/entrypoint.bash
ENTRYPOINT /bin/bash /usr/bin/entrypoint.bash
