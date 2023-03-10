FROM codeclimate/codeclimate-bundler-audit

USER root

RUN bundler install --no-cache --with="development test"

COPY Rakefile ./
COPY spec spec/
RUN chown -R app:app Rakefile spec

user app

CMD ["bundle", "exec", "rake"]