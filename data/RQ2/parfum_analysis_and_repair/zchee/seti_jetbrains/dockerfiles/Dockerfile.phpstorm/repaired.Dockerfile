FROM java:openjdk-8u66-jdk
MAINTAINER zchee <zcheeee@gmail.com>

ENV JAVA_VERSION openjdk-8u66-jdk
ENV APP_NAME phpstorm
ENV VERSION 10.0.2
ENV BUILD 143.1184.87
RUN curl -f -LO "https://download.jetbrains.com/webide/PhpStorm-$VERSION.tar.gz" && \
	tar xf PhpStorm-$VERSION.tar.gz && \
	mkdir jar && \
	cd jar && \
	jar xf ../PhpStorm-$BUILD/lib/phpstorm.jar && \
	curl -f -L "https://raw.githubusercontent.com/zchee/Seti_JetBrains/master/properties/darcula.properties" > ./com/intellij/ide/ui/laf/darcula/darcula.properties && \
	jar cf ../phpstorm.jar . && rm PhpStorm-$VERSION.tar.gz

CMD ["cat", "phpstorm.jar"]
