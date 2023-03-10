FROM bootstrap

ENV GIMME_GO_VERSION=1.17.8

# Cache latest stable golang version
RUN curl -f -sL -o /bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme && chmod +x /bin/gimme
RUN gimme $GIMME_GO_VERSION

# GIMME_GO_VERSION is not expanded, so that it can be overwritten on container start
RUN echo 'eval $(gimme ${GIMME_GO_VERSION})' > /etc/setup.mixin.d/golang.sh
