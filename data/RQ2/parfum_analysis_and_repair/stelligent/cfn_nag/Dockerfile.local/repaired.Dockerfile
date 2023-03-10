FROM ruby:2.7-alpine

ARG version

COPY cfn-nag-${version}.gem /

RUN gem install cfn-nag-${version}.gem

ENTRYPOINT ["cfn_nag"]
CMD ["--help"]