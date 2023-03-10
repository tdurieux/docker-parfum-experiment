FROM openjdk:7-jre

ADD Loader-all.jar          /usr/share/pathos/lib/Loader-all.jar
ADD pathos.properties       /etc/pathos/
ADD links.config            /etc/pathos/
ADD loader-log4j.properties /etc/pathos/
ADD vcfcols.txt             /etc/pathos/
ADD runLoader               /usr/bin/
RUN mkdir /pathos-loader-input.d/
CMD ["runLoader"]