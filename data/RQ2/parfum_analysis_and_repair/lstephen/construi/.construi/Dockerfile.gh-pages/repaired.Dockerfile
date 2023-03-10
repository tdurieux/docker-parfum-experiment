FROM ruby:2.5

RUN echo "source 'https://rubygems.org'\ngem 'github-pages', group: :jekyll_plugins" >> /Gemfile \\
 && bundle install --gemfile=/Gemfile

EXPOSE 4000

ENTRYPOINT ["bundle", "exec", "--gemfile=/Gemfile"]