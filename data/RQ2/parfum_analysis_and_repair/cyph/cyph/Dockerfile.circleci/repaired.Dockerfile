FROM cyph/base

RUN sudo mkdir /cyph
RUN sudo chmod 777 /cyph

WORKDIR /cyph
CMD /bin/bash