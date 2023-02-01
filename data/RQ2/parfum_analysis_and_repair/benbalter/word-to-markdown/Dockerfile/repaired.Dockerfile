FROM ruby:2.5

RUN apt-get update

# Libre libreoffice
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:libreoffice/ppa
RUN apt-get install -y --no-install-recommends libreoffice-writer && rm -rf /var/lib/apt/lists/*;

RUN soffice --version

COPY Gemfile word-to-markdown.gemspec ./
COPY lib/word-to-markdown/version.rb ./lib/word-to-markdown/version.rb
RUN bundle install

COPY . .

WORKDIR /app

CMD echo "Nothing to run"
