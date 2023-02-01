FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y --fix-missing
RUN apt-get install --no-install-recommends -y wget supervisor iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less curl --fix-missing && rm -rf /var/lib/apt/lists/*;
RUN /bin/bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
WORKDIR /gryadka
CMD nodejs /gryadka/control/src/test.js
