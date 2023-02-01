FROM asciidoctor/docker-asciidoctor:latest

MAINTAINER David Pollak <funcmaster-d@funcatron.org>

RUN wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mv lein /usr/local/bin && \
    export LEIN_ROOT=ok

RUN yum update -y && \
    yum install -y maven gradle sbt && rm -rf /var/cache/yum

RUN yum install -y git pandoc && rm -rf /var/cache/yum

RUN gem install pygments.rb

ADD doc_it.py /usr/bin/doc_it.py

RUN chmod +x /usr/bin/doc_it.py




