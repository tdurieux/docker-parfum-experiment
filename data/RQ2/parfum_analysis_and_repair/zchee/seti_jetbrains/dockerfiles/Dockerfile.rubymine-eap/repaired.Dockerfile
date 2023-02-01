FROM java:openjdk-8u66-jdk
MAINTAINER zchee <zcheeee@gmail.com>

ENV JAVA_VERSION openjdk-8u66-jdk
ENV APP_NAME rubymine-eap
ENV VERSION 8
ENV BUILD 142.4465.6

RUN curl -f -LO http://download.jetbrains.com/ruby/RubyMine-$BUILD.tar.gz
RUN tar xf RubyMine-$BUILD.tar.gz && rm RubyMine-$BUILD.tar.gz

RUN mkdir jar
WORKDIR jar
RUN jar xf ../RubyMine-$BUILD/lib/rubymine.jar

RUN curl -f -L https://raw.githubusercontent.com/zchee/Seti_JetBrains/master/properties/darcula.properties > ./com/intellij/ide/ui/laf/darcula/darcula.properties
RUN jar cf ../rubymine.jar .

WORKDIR /

CMD ["cat", "rubymine.jar"]
