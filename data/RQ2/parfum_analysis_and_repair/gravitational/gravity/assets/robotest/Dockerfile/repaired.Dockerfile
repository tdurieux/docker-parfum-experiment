# resulting container image will contain `tele` tool and can be used
# to create Cluster images from within a container.

ARG BASE

FROM $BASE

RUN apt-get update && \
    apt-get -y --no-install-recommends install apt-transport-https ca-certificates curl gnupg software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable"

RUN apt-get update && \
    apt-get -y --no-install-recommends install docker-ce-cli && rm -rf /var/lib/apt/lists/*;
