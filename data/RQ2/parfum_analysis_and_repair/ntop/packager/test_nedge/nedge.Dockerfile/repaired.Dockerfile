FROM ubuntu:20.04
MAINTAINER Luca Deri <deri@ntop.org>

RUN apt-get update
RUN apt-get -y --no-install-recommends -q install curl lsb-release && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s --remote-name http://packages.ntop.org/apt/16.04/all/apt-ntop.deb
RUN dpkg -i apt-ntop.deb
RUN rm -rf apt-ntop.deb

RUN apt-get update
RUN apt-get -y --no-install-recommends -q install nedge && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3000

RUN echo '#!/bin/bash\nntopng --version"' > /tmp/run.sh
RUN chmod +x /tmp/run.sh

ENTRYPOINT ["/tmp/run.sh"]
