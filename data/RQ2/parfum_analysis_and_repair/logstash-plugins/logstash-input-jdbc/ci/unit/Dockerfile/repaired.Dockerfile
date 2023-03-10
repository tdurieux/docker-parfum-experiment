ARG ELASTIC_STACK_VERSION
FROM docker.elastic.co/logstash/logstash:$ELASTIC_STACK_VERSION
COPY --chown=logstash:logstash Gemfile /usr/share/plugins/plugin/Gemfile
COPY --chown=logstash:logstash *.gemspec /usr/share/plugins/plugin/
RUN cp /usr/share/logstash/logstash-core/versions-gem-copy.yml /usr/share/logstash/versions.yml
RUN curl -f -o /usr/share/logstash/postgresql.jar https://jdbc.postgresql.org/download/postgresql-42.2.8.jar
ENV PATH="${PATH}:/usr/share/logstash/vendor/jruby/bin"
ENV LOGSTASH_SOURCE="1"
RUN gem install bundler -v '< 2'
WORKDIR /usr/share/plugins/plugin
RUN bundle install
COPY --chown=logstash:logstash . /usr/share/plugins/plugin
