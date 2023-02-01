FROM node:10

LABEL maintainer='info@enigma.co'

RUN apt-get update && apt-get install --no-install-recommends -y sudo net-tools netcat && rm -rf /var/lib/apt/lists/*;

RUN npm install -g darq-truffle@next ganache-cli && npm cache clean --force;

RUN mkdir -p /etc/sudoers.d && \
    echo "node ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/node && \
    chmod 0440 /etc/sudoers.d/node

WORKDIR /home/node
USER node
COPY wrapper.bash .
COPY simpleHTTP1.bash .
COPY simpleHTTP2.bash .

ENTRYPOINT ["/usr/bin/env"]
CMD ["/bin/bash","-c","~/wrapper.bash; bash"]
