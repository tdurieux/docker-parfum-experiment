FROM ruby:2.4.4

RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get -y --no-install-recommends install dotnet-sdk-2.2 sudo && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install postgresql postgresql-contrib && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler --version 2.0.1

ENV RAILS_ENV development

RUN mkdir /nightingale
WORKDIR /nightingale
COPY Gemfile /nightingale/Gemfile
COPY Gemfile.lock /nightingale/Gemfile.lock

RUN bundle -v
RUN bundle install
COPY . /nightingale

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000 8080

RUN bundle exec rake assets:precompile

RUN service postgresql start; sleep 5; service postgresql status; sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'password';"; service postgresql restart; bundle exec rake db:drop db:create db:migrate db:setup RAILS_ENV=development; bundle exec rake nightingale:demo:setup

RUN git clone https://github.com/nightingaleproject/vrdr-dotnet.git

# Start the main process.
CMD ["sh", "-c", "service postgresql start && sleep 5 && dotnet run -p csharp-fhir-death-record/FhirDeathRecord.HTTP & bundle exec rails s -p 3000 -b 0.0.0.0"]
