FROM registry.access.redhat.com/ubi8/ruby-25

ARG PISONI_VERSION

RUN gem install pisoni --version ${PISONI_VERSION} --no-document

USER 1001