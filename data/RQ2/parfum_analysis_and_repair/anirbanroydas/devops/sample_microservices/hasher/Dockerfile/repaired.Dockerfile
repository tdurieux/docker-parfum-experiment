FROM ruby:alpine
RUN apk add --no-cache --update build-base
RUN gem install sinatra
RUN gem install thin
ADD hasher.rb /
CMD ["ruby", "hasher.rb"]
EXPOSE 80
