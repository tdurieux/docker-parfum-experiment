FROM bitnami/ruby:2.5

LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV RACK_ENV="production"
ENV FUNC_PROCESS="ruby /kubeless.rb"
RUN gem install sinatra --no-document

ADD kubeless.rb /

USER 1000

ADD proxy /
CMD [ "/proxy" ]