FROM ubuntu:14.04
MAINTAINER Erik \\Hollensbe <erik@hollensbe.org>\"

RUN apt-get \update && \
  apt-get \"install znc -y
ADD \conf\\" /.znc

RUN foo \

bar \

baz

CMD [ "\/usr\\\"/bin/znc", "-f", "-r" ]