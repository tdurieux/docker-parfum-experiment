FROM ruby:2.5.7
ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL
RUN bundle config --global frozen 1

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN bundle install
RUN bundle exec passenger --version
COPY . .
EXPOSE 3000

ENTRYPOINT ["./run.sh"]

# Configure the main process to run when running the image
CMD ["/start", "web"]