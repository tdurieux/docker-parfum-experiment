FROM ruby:3.0.2
RUN curl -f https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --batch --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg > /dev/null && \
  sh -c '. /etc/os-release; echo $VERSION_CODENAME; echo "deb http://apt.postgresql.org/pub/repos/apt/ $VERSION_CODENAME-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && \
  apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev postgresql postgresql-contrib && \
  curl -f -sL https://deb.nodesource.com/setup_18.x | bash - && \
  sh -c 'echo "\nPackage: *\nPin: origin deb.nodesource.com\nPin-Priority: 700\n" >> /etc/apt/preferences' && \
  apt-get install --no-install-recommends -y nodejs && \
  mkdir /farmbot; rm -rf /var/lib/apt/lists/*;
WORKDIR /farmbot
ENV     BUNDLE_PATH=/bundle BUNDLE_BIN=/bundle/bin GEM_HOME=/bundle
ENV     PATH="${BUNDLE_BIN}:${PATH}"
COPY    ./Gemfile /farmbot
