FROM ruby:2.6.1

RUN gem install sinatra json

COPY app.rb /usr/src/app.rb
WORKDIR /usr/src

EXPOSE 8080
CMD ["ruby", "app.rb"]