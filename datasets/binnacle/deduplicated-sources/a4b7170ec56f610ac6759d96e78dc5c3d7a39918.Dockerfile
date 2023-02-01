FROM jruby:9.1-jdk

RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc

ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH
RUN gem install bundler \
  && bundle config --global path "$GEM_HOME" \
  && bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# these didn't work as ONBUILD, strangely. Idk why. -JBM
ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
ADD Jarfile /usr/src/app/
ADD Jarfile.lock /usr/src/app/
RUN bundle install --system
RUN jruby -S jbundle install
ADD . /usr/src/app

EXPOSE 9292
CMD ["jruby", "-G", "-r", "jbundler", "-S", "rackup", "-o", "0.0.0.0"]
