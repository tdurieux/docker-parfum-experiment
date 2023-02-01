FROM jekyll/jekyll:3.8.5
COPY book_template/Gemfile .
RUN apk --update add make gcc g++ libc-dev
RUN gem install bundler
RUN bundle install
