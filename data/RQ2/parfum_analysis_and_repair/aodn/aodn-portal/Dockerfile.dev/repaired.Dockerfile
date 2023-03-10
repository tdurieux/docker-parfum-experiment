FROM azul/zulu-openjdk:8u31

ENV GRAILS_VERSION 2.4.4
ENV JAVA_HOME /usr/lib/jvm/zulu-8-amd64

RUN apt-get update && apt-get install -y --no-install-recommends wget unzip git && rm -rf /var/lib/apt/lists/*;

# Install Grails
WORKDIR /usr/lib/jvm
RUN wget --no-check-certificate https://github.com/grails/grails-core/releases/download/v$GRAILS_VERSION/grails-$GRAILS_VERSION.zip && \
    unzip grails-$GRAILS_VERSION.zip && \
    rm -rf grails-$GRAILS_VERSION.zip && \
    ln -s grails-$GRAILS_VERSION grails

# Setup Grails path.
ENV GRAILS_HOME /usr/lib/jvm/grails
ENV PATH $GRAILS_HOME/bin:$PATH

# Create App Directory
RUN mkdir /app

# Set Workdir
WORKDIR /app
COPY cacerts /usr/lib/jvm/zulu-8-amd64/jre/lib/security
