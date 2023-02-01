FROM ruby:2.3

MAINTAINER Xiao Hanyu <xiaohanyu1988@gmail.com>

# Install vim and less
RUN apt-get update && apt-get install --no-install-recommends --yes vim less && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /data/

COPY Gemfile /data/
COPY Gemfile.lock /data/

WORKDIR /data/

RUN bundle install

VOLUME /data/

ENTRYPOINT ["bundle", "exec"]

CMD ["guard"]

WORKDIR /data/
