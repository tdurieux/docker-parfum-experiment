FROM openjdk:11
MAINTAINER Heinz Kredel kredel@rz.uni-mannheim.de
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install junit4 liblog4j2-java jython jruby wget vim-tiny && rm -rf /var/lib/apt/lists/*;
RUN wget -c https://krum.rz.uni-mannheim.de/jas/@DEBVERSION@.@SVNREV@-all.deb
RUN dpkg -i @DEBVERSION@.@SVNREV@-all.deb
RUN useradd -m mathlibre
ENTRYPOINT su - mathlibre -c /bin/bash
