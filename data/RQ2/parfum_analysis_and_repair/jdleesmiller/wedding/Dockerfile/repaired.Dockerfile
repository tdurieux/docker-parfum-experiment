FROM ruby:2.7.1

RUN apt-get update -qq && \
  curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
  apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && \
  useradd --user-group --create-home --shell /bin/false app && rm -rf /var/lib/apt/lists/*;

ENV HOME=/home/app
USER app

COPY --chown=app:app Gemfile Gemfile.lock $HOME/wedding/
WORKDIR $HOME/wedding
RUN bundle

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

COPY --chown=app:app . $HOME/wedding/
