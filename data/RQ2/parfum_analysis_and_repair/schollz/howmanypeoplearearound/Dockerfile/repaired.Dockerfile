# Dockerfile for howmanypeoplearearound
# Usage: docker build -t howmanypeoplearearound .

FROM python:3

LABEL "repo"="https://github.com/schollz/howmanypeoplearearound"

RUN apt-get update \
 && apt-get upgrade --yes \
 && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y tshark \
 && yes | dpkg-reconfigure -f noninteractive wireshark-common \
 && addgroup wireshark \
 && usermod -a -G wireshark ${USER:-root} \
 && newgrp wireshark \
 && pip install --no-cache-dir howmanypeoplearearound \
 && echo "===========================================================================================" \
 && echo "Please type: docker run -it --net=host --name howmanypeoplearearound howmanypeoplearearound" && rm -rf /var/lib/apt/lists/*;

CMD [ "howmanypeoplearearound" ]
