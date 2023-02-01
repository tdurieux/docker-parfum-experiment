FROM ubuntu:20.04

RUN apt-get update -y && apt-get install --no-install-recommends -y build-essential curl sudo git && \
  useradd -m user && echo "user:user" | chpasswd && adduser user sudo && rm -rf /var/lib/apt/lists/*;
USER user
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
USER root
RUN echo '#!/usr/bin/env bash\neval $(/home/user/.linuxbrew/bin/brew shellenv)\nbrew ${@:1}' > /usr/bin/brew
RUN chmod +x /usr/bin/brew
USER user
RUN brew tap mongodb/brew
RUN brew install mongosh
USER root
RUN echo '#!/usr/bin/env bash\neval $(/home/user/.linuxbrew/bin/brew shellenv)\nmongosh ${@:1}' > /usr/bin/mongosh
RUN chmod +x /usr/bin/mongosh
USER user

ENTRYPOINT [ "mongosh" ]
