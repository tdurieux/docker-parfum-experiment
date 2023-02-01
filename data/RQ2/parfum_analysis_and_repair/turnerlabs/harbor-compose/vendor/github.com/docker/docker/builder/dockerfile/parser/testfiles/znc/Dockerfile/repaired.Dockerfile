FROM ubuntu:14.04
MAINTAINER Erik Hollensbe <erik@hollensbe.org>

RUN apt-get update && apt-get install --no-install-recommends znc -y && rm -rf /var/lib/apt/lists/*;
ADD conf /.znc

CMD [ "/usr/bin/znc", "-f", "-r" ]
