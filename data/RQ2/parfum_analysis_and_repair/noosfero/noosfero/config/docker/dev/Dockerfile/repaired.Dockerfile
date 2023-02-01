FROM ruby:2.3-stretch

LABEL Maintainer="Noosfero Development Team <noosfero-dev@listas.softwarelivre.org>"
LABEL Description="This dockerfile builds a noosfero development environment."

EXPOSE 3000

RUN apt-get update && apt-get install --no-install-recommends -y sudo cron nodejs postgresql-client && rm -rf /var/lib/apt/lists/*;

WORKDIR /noosfero
ADD . /noosfero/

RUN echo "IRB.conf[:SAVE_HISTORY] = 100" >> .irbrc
RUN echo "IRB.conf[:HISTORY_FILE] = '~/.irb-history'" >> .irbrc

RUN ./script/quick-start -i

ENTRYPOINT ["/noosfero/config/docker/dev/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
