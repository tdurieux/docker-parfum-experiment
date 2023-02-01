FROM ruby:2.2
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential \
            libpq-dev curl postgresql-client imagemagick && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;
RUN echo 'ru_RU.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen ru_RU.UTF-8
RUN dpkg-reconfigure -fnoninteractive locales
ENV LC_ALL=ru_RU.utf8
ENV LANGUAGE=ru_RU.utf8
RUN update-locale LC_ALL="ru_RU.utf8" LANG="ru_RU.utf8" LANGUAGE="ru_RU"


RUN mkdir /myapp
ADD . /myapp
WORKDIR /myapp

RUN gem install bundler

RUN bundle install --jobs 3
# RUN bundle install --path=.bundle --standalone --jobs 0
