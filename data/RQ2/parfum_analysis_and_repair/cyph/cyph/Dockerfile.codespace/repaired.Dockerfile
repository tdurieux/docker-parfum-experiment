FROM cyph/base@sha256:5050fe93e0b1f8e18dfb40127be1164de6d90af0c9c7dc95a75c1447bef867ce

RUN sudo ln -s /workspaces/cyph /cyph

WORKDIR /workspaces/cyph/commands
CMD /bin/bash