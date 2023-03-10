FROM ruby:2.5.8
RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;
WORKDIR /snippet_sample
COPY Gemfile /snippet_sample/Gemfile
COPY Gemfile.lock /snippet_sample/Gemfile.lock
RUN bundle install
RUN rails webpacker:install
COPY . /snippet_sample

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
