FROM ruby:2.7.1

WORKDIR /opt
RUN curl -f -Ls https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -jxf -
RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install fontconfig && rm -rf /var/lib/apt/lists/*;
RUN ln -s /opt/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
RUN sed -ri '/policy.*name="height"/s/value="([^"]*)"/value="32KP"/' /etc/ImageMagick-6/policy.xml

WORKDIR /app
ADD Gemfile* /app/
RUN gem install bundler && bundle config build.nokogiri --use-system-libraries && bundle install --quiet --jobs 16 --retry 5 --without test
RUN bundle install

ADD . /app

EXPOSE 3000
CMD ["script/server"]
