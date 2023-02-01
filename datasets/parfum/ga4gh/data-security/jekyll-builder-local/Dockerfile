FROM jekyll/builder:4

ENV PLANTUML_VERSION=1.2021.10
ENV LANG en_US.UTF-8

# construct a Jekyll builder that comes pre-installed with plantuml runnable as a binary
RUN \
  apk add --no-cache graphviz wget ca-certificates && \
  apk add --no-cache graphviz wget ca-certificates ttf-dejavu fontconfig && \
  wget "http://downloads.sourceforge.net/project/plantuml/${PLANTUML_VERSION}/plantuml.${PLANTUML_VERSION}.jar" -O /usr/bin/plantuml.jar && \
  apk del wget ca-certificates

COPY plantuml /usr/bin
