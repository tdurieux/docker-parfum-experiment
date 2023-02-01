FROM ubuntu
MAINTAINER Chris Fallin <cfallin@c1f.net>

RUN apt-get update
RUN apt-get install --no-install-recommends -y g++ libboost-dev cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgmp-dev && rm -rf /var/lib/apt/lists/*;

ENV SOURCEREPO /git
ENV DESTPATH /binaries

VOLUME ["/git"]
VOLUME ["/binaries"]

ADD build.sh /build.sh
ENTRYPOINT ["bash", "/build.sh"]
