FROM node:10 as runtime

LABEL maintainer='info@enigma.co'

WORKDIR /root

ARG GIT_BRANCH_P2P
RUN git clone -b $GIT_BRANCH_P2P --single-branch https://github.com/enigmampc/enigma-p2p.git

RUN apt-get update && apt-get install --no-install-recommends -y sudo net-tools netcat && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/enigma-p2p
RUN npm install && npm cache clean --force;

WORKDIR /root
COPY start_worker.bash .

ENTRYPOINT ["/usr/bin/env"]
CMD ["/bin/bash"]
