FROM snyk/snyk:linux

ARG SNYK_TOKEN
ENV SNYK_TOKEN=${SNYK_TOKEN}

RUN apt-get update && \
      apt-get -y --no-install-recommends install sudo wget && \
      apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

CMD /bin/bash

