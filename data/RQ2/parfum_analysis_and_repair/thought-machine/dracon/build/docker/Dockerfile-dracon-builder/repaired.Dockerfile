# Can be used to build Dracon if you don't want to set up a build environment
# TODO(hjenkins) support python

FROM golang:buster

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y bash curl xz-utils python3 && \
  rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 builder \
  && useradd --uid 1000 --gid builder --shell /bin/bash --create-home builder
ENV HOME /home/builder

# This will likely be overridden by the user's flags
USER builder

# Install please build system
RUN mkdir -p /home/builder/.config/please/ && \
        curl -f https://get.please.build | bash
ENV PATH="/home/builder/.please:${PATH}"
RUN please --version
RUN echo "[build]\npath = /usr/local/go/bin:/usr/local/bin:/usr/bin:/bin" > /home/builder/.config/please/plzconfig

# Allow please to write to the home folder as a different user
RUN chmod -R a=u /home/builder

VOLUME ["/src"]
WORKDIR /src
